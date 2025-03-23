require 'rbnacl'
require 'base58'

module SolanaRails

  class Keypair

    def self.generate
      signing_key = RbNaCl::Signatures::Ed25519::SigningKey.generate
      private_key_bytes = signing_key.to_bytes
      keys(signing_key, private_key_bytes)
    end

    def self.from_private_key(private_key_hex)
      raise ArgumentError, "**** Invalid private key length" unless private_key_hex.size == 64
      private_key_bytes = [private_key_hex].pack('H*')
      signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new(private_key_bytes)
      keys(signing_key, private_key_bytes)
    end

    def self.load_keypair(file_path)
      keypair_data = JSON.parse(File.read(file_path))
      raise "**** Invalid keypair length: expected 64 bytes, got #{keypair_data.length}" unless keypair_data.length == 64

      private_key_bytes = keypair_data[0, 32].pack('C*')
      public_key_bytes = keypair_data[32, 32].pack('C*')
      signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new(private_key_bytes)
      raise "**** Public key mismatch" unless signing_key.verify_key.to_bytes == public_key_bytes

      keys(signing_key, private_key_bytes)
    rescue JSON::ParserError => e
      raise "**** Failed to parse JSON: #{e.message}"
    end

    private

    def self.keys(signing_key, private_key_bytes)
      public_key_bytes = signing_key.verify_key.to_bytes
      private_key_hex = private_key_bytes.unpack1('H*') # Hex format for private key
      OpenStruct.new(
        public_key: Base58.binary_to_base58(public_key_bytes, :bitcoin),
        private_key: private_key_hex,
        full_private_key: Base58.binary_to_base58((private_key_bytes + public_key_bytes), :bitcoin)
      )
    end
  end

end
