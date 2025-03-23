require 'rbnacl'

module SolanaRails

  class Transaction

    include SolanaRails::Base
    
    SIGNATURE_LENGTH = 64
    PACKET_DATA_SIZE = 1280 - 40 - 8
    DEFAULT_SIGNATURE = Array.new(64, 0)

    def initialize(**args)
      @message = args[:message]
      @signatures = args[:signatures] || []
    end

    class << self

      def from_message(message)
        self.new(
          message: message
        )
      end

    end # class << self

    def message
      @message
    end

    def signatures
      @signatures
    end

    def sign(payer_keypairs)
      pubkeys =  payer_keypairs.map{ |kp| kp[:public_key]}
      raise 'must_include_at_least_one_keypair' if pubkeys.blank?

      message.account_keys.each do |pubkey|
        # get keypairs in sequence with account_keys
        keypair = payer_keypairs.detect{ |kp| kp[:public_key] == pubkey }

        # not a payer keypair
        next unless keypair.present?

        private_key_bytes = [keypair[:private_key]].pack('H*')

        signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new(private_key_bytes)

        signature = signing_key.sign(message.serialize.pack('C*')).bytes

        raise 'keypair_failed_to_produce_signature' if signature.blank?
        raise "signature_not_valid" unless signature.length == SIGNATURE_LENGTH

        @signatures << signature
      end

      raise 'no_signatures_found' if signatures.blank?
      true
    end

    def serialize
      transaction = Base.encode_compact_u16(signatures.length)
      signatures.each do |signature|
        raise 'signature_has_invalid_length' unless (signature.length == 64)
        transaction += signature
      end
      transaction += message.serialize
    end

    def to_hash
      { transaction: {
          message: message.to_hash,
          signatures: signatures
        }
      }
    end

    def to_json
      self.to_hash.to_json
    end

    def to_base64
      Base64.strict_encode64(serialize.pack('C*'))
    end

  end
end
