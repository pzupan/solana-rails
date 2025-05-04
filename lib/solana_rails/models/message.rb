require_relative '../data_types/layout'

module SolanaRails
  
  class Message
    PUBKEY_LENGTH = 32

    include SolanaRails::Base

    def initialize(**args)
      @account_keys          = args[:account_keys]
      @header                = args[:header]
      @recent_blockhash      = args[:recent_blockhash]      || ''
      @instructions          = args[:instructions]          || []
      @address_table_lookups = args[:address_table_lookups] || []
      @program_id_index      = args[:program_id_index]      || nil
      @account_indexes       = args[:account_indexes]       ||
      @data                  = args[:data]                  || []

      error_check_account_keys
      error_check_header
      error_check_recent_blockhash
      error_check_instructions
    end

    class << self

      def from_transaction_instruction(transaction_instruction)
        self.new(
          account_keys:     transaction_instruction.account_keys,
          header:           transaction_instruction.header,
          recent_blockhash: transaction_instruction.recent_blockhash,
          instructions:     transaction_instruction.instructions,
          program_id_index: transaction_instruction.program_id_index,
          account_indexes:  transaction_instruction.account_indexes,
          data:             transaction_instruction.data
        )
      end

    end

    def account_keys
      @account_keys.map{ |ac| JSON.parse(ac.to_json, object_class: OpenStruct) }
    end

    def account_indexes
      @account_indexes
    end

    def header
      OpenStruct.new(@header)
    end

    def instructions
      @instructions.map{ |i| JSON.parse(i.to_json, object_class: OpenStruct) }
    end

    def program_id_index
      @program_id_index
    end

    def recent_blockhash
      @recent_blockhash
    end

    def data
      @data
    end

    def address_table_lookups
      @address_table_lookups.map{ |atl| JSON.parse(atl.to_json, object_class: OpenStruct) }
    end

    def serialize

      # header specifies the number of signer and read-only accounts
      # 3 bytes
      #  1. u8 number of signatures required for this message to be considered valid, signer must be first key in account keys,
      #  2. u8 number of signed keys that are read only
      #  3. u8 number of unsigned keys that are read only
      message_header = [
        header.num_required_signatures,
        header.num_readonly_signed_accounts,
        header.num_readonly_unsigned_accounts
      ]

      # account addresses is an array of addresses required by the instructions
      # 32 bytes each
      # Array begins with compact-u16 number indicating how many addresses it contains. Must be in sequence
      # 1. Accounts that are writable and signers
      # 2. Accounts that are read-only and signers
      # 3. Accuunts that are writable and not signers
      # 4. Accounts that are read-only and not signers
      key_count = Base.encode_compact_u16(account_keys.length)

      # account_keys.map(&:key)

      # recent blockhash
      # 32 bytes

      # instructions is an array of instructions to be executed
      # 1. starts with compact-u16 count of instructions
      # 2. program ID index: an u8 index that points to the program's address in the account addresses array. This is the program that will process the instruction
      # 3. account indexes. an array of u8 indexes that point to the account addresses required for this instruction
      # 4. instruction data. a byte array specifying which instructions to invoke on the program and any additional data required by the instruction (eg: function arguments)

      instruction_count = Base.encode_compact_u16(instructions.length)

      instructions = [
        program_id_index,
        account_indexes,
        data
      ]

      (message_header + key_count + account_keys + [recent_blockhash] + instruction_count + instructions).flatten
    end

    def to_hash
      message = {
        header:               header.to_h,
        account_keys:         account_keys,
        recent_blockhash:     recent_blockhash,
        instructions:         instructions.map(&:to_h),
      }
      message[:address_table_lookups] = address_table_lookups if address_table_lookups.present?
      message
    end

    def to_json
      self.to_hash.to_json
    end

    protected

    def error_check_account_keys
      raise 'must_include_account_keys' if account_keys.blank?
    end

    def error_check_header
      raise 'header_must_be_an_object' unless @header.is_a?(Hash)
      raise 'header_must_include_num_readonly_signed_accounts' unless header.num_readonly_signed_accounts.present?
      raise 'header_must_include_num_readonly_unsigned_accounts'  unless header.num_readonly_unsigned_accounts.present?
      raise 'header_must_include_num_required_signatures'  unless header.num_required_signatures.present?
    end

    def error_check_recent_blockhash
      raise 'must_include_recent_blockhash' if recent_blockhash.blank?
    end

    def error_check_instructions
      raise 'must_include_instructions' if instructions.blank?
    end

  end
end
