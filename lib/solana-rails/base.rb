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

    def self.base58_encode(bytes)
      Base58.binary_to_base58(bytes, :bitcoin)
    end

    def self.base58_decode(base58)
      Base58.base58_to_binary(base58, :bitcoin)
    end

    def self.base64_encode(bytes)
      Base64.strict_encode64(bytes)
    end

    def self.base64_decode(base64)
      Base64.strict_decode64(base64)
    end
  end
  Base.freeze
end
