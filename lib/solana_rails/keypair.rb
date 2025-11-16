require 'rbnacl'
require 'base58'

module SolanaRails

  class Keypair

    class << self

      def generate
        signing_key = RbNaCl::Signatures::Ed25519::SigningKey.generate
        keys(signing_key)
      end

      def from_private_key(private_key)
        raise ArgumentError, "**** Invalid private key length" unless private_key.size == 64
        private_key_bytes = Base58.base58_to_binary(private_key)
        signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new(private_key_bytes)
        keys(signing_key)
      end

      def from_secret_key(secret_key)
        raise ArgumentError, "**** Invalid secret key length" unless secret_key.length == 64
        create_keypair(secret_key)
      end

      def load_keypair(file_path)
        secret_key = JSON.parse(File.read(file_path))
        # puts "**** Keypair Secret Key: #{secret_key}"
        from_secret_key(secret_key)
      end

      def secret_key(full_private_key)
        raise ArgumentError, "**** Invalid private key: expected 88 characters, got #{full_private_key.length}" unless full_private_key.length == 88

        # convert from base58 to binary
        binary_string = Base58.base58_to_binary(full_private_key)

        # Convert the binary string to a byte array (Array of Integers)
        binary_string.bytes
      end

    end

    private

    def self.keys(signing_key, secret_key=nil)
      public_key_bytes = signing_key.verify_key.to_bytes
      private_key_hex = signing_key.to_bytes.unpack('H*') # Hex format for private key
      secret_key ||= signing_key.to_bytes.unpack('C*') +  public_key_bytes.unpack('C*')

      OpenStruct.new(
        public_key: Base58.binary_to_base58(public_key_bytes, :bitcoin),
        private_key: private_key_hex,
        secret_key: secret_key
      )
    end

    def self.create_keypair(secret_key)
      private_key_bytes = secret_key.slice(0, 32)
      public_key_bytes = secret_key.slice(32, 64)

      # Packs the contents into a 8-bit unsigned (unsigned char)
      private_key_bin = private_key_bytes.pack('C*')
      public_key_bin = public_key_bytes.pack('C*')

      signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new(private_key_bin)
      raise "**** Public key mismatch" unless signing_key.verify_key.to_bytes == public_key_bin

      keys(signing_key, secret_key)

      rescue JSON::ParserError => e
        raise "**** Failed to parse JSON: #{e.message}"
    end

  end

end
