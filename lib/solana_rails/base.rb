require 'base58'
require 'base64'

module SolanaRails
  module Base

    TOKEN_PROGRAM_ID = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA'
    TOKEN_2022_PROGRAM_ID = 'TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb'
    ASSOCIATED_TOKEN_PROGRAM_ID = 'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL'
    SYSTEM_PROGRAM_ID = '11111111111111111111111111111111'
    SYSVAR_RENT_ID = 'SysvarRent111111111111111111111111111111111'

    PACKET_DATA_SIZE = 1232

    module InstructionType
      CREATE_ACCOUNT            = 0
      ASSIGN                    = 1
      TRANSFER                  = 2
      CREATE_ACCOUNT_WITH_SEED  = 3
      ADVANCE_NONCE_ACCOUNT     = 4
      WITHDRAW_NONCE_ACCOUNT    = 5
      INITIALIZE_NONCE_ACCOUNT  = 6
      AUTHORIZE_NONCE_ACCOUNT   = 7
      ALLOCATE                  = 8
      ALLOCATE_WITH_SEED        = 9
      ASSIGN_WITH_SEED          = 10
      TRANSFER_WITH_SEED        = 11
    end

    class << self

      def base58_encode(bytes)
        Base58.binary_to_base58(bytes, :bitcoin)
      end

      def base58_decode(base58)
        Base58.base58_to_binary(base58, :bitcoin)
      end

      def base64_encode(bytes)
        Base64.strict_encode64(bytes)
      end

      def base64_decode(base64)
        Base64.strict_decode64(base64)
      end

       # Encodes a length as a variable-length byte array.
      def encode_length(length)
        raise "must_be_an_integer" unless length.is_a?(Integer)
        raise 'integer_must_be_greater_than_or_equal_to_zero' unless length >= 0

        bytes = []
        loop do
          byte = length & 0x7F
          length >>= 7
          if length.zero?
            bytes << byte
            break
          else
            bytes << (byte | 0x80)
          end
        end
        bytes
      end

      # converts integer to solana u8 array
      def encode_u8(integer)
        raise "must_be_an_integer" unless integer.is_a?(Integer)
        raise "must_be_greater_than_or_equal_zero" if integer.negative?

        if integer >= 256**8
          raise "integer_to_large_to_fit_in_8_bytes"
        end

        [integer].pack('C')
      end


      # converts integer to Solana compact-u16 array
      def encode_compact_u16(integer)
        raise "must_be_an_integer" unless integer.is_a?(Integer)
        raise 'integer_must_be_greater_than_or_equal_to_zero' unless integer >= 0

        arr_of_bytes = []
        arr_count = 0
        loop do
          # remove the most significant bit
          bytes = [(integer & 0x7f)].pack('C')

          # shift right 7 bits
          integer >>= 7
          # if integer still has a value [was greater than 127]
          if integer > 0
            # max of 3 elements
            raise 'exceeds_expected_elements_for_compact_u16' if arr_count == 2
            # set the most significant bit to 1 indicating there will be another element
            arr_of_bytes << [(bytes | 0x80)].pack('C')
          else
            # there will be no more elements to follow
            arr_of_bytes << bytes
            break
          end
          arr_count += 1
        end
        arr_of_bytes
      end

      def bytes_to_base58(bytes)
        raise ArgumentError, "must_by_an_array_of_bytes" unless bytes.is_a?(Array)

        Base58.binary_to_base58(bytes.pack('C*'), :bitcoin)
      end

      def base58_to_bytes(base58_string)
        raise ArgumentError, "must_be_string" unless base58_string.is_a?(String) && !base58_string.blank?

        Base58.base58_to_binary(base58_string, :bitcoin)

        rescue ArgumentError
          raise "invalid_base58_string: #{base58_string}"
      end

      def sha256(data)
        raise ArgumentError, "must_be_string" unless data.is_a?(String)

        Digest::SHA256.hexdigest(data)
      end

    end # class << self

  end
  Base.freeze
end
