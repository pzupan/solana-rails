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
        )
      end

    end

    def account_keys
      @account_keys.map{ |ac| JSON.parse(ac.to_json, object_class: OpenStruct) }
    end

    def header
      OpenStruct.new(@header)
    end

    def instructions
      @instructions.map{ |i| JSON.parse(i.to_json, object_class: OpenStruct) }
    end

    def recent_blockhash
      @recent_blockhash
    end

    def address_table_lookups
      @address_table_lookups.map{ |atl| JSON.parse(atl.to_json, object_class: OpenStruct) }
    end

    def serialize
      num_keys = account_keys.length
      key_count = Base.encode_compact_u16(num_keys)

      layout = SolanaRails::DataTypes::Layout.new({
        num_required_signatures: :blob1,
        num_readonly_signed_accounts: :blob1,
        num_readonly_unsigned_accounts: :blob1,
        key_count: SolanaRails::DataTypes::Blob.new(key_count.length),
        keys: SolanaRails::DataTypes::Sequence.new(num_keys, SolanaRails::DataTypes::Blob.new(32)),
        recent_blockhash: SolanaRails::DataTypes::Blob.new(32)
      })

      sign_data = layout.serialize({
        num_required_signatures: header.num_required_signatures,
        num_readonly_signed_accounts: header.num_readonly_signed_accounts,
        num_readonly_unsigned_accounts: header.num_readonly_unsigned_accounts,
        key_count: key_count,
        keys: account_keys.map{ |k| Base.base58_to_bytes(k) },
        recent_blockhash: Base.base58_to_bytes(recent_blockhash)
      })

      instruction_count = Base.encode_compact_u16(instructions.length)
      sign_data += instruction_count

      data = instructions.map do |instruction|

       instruction_layout = SolanaRails::DataTypes::Layout.new({
          program_id_index: :uint8,
          key_indices_count: SolanaRails::DataTypes::Blob.new(key_count.length),
          key_indices: SolanaRails::DataTypes::Sequence.new(num_keys, SolanaRails::DataTypes::Blob.new(8)),
          data_length: SolanaRails::DataTypes::Blob.new(key_count.length),
          data: SolanaRails::DataTypes::Sequence.new(num_keys, SolanaRails::DataTypes::UnsignedInt.new(8)),
       })

        key_indices_count = Base.encode_compact_u16(instruction.accounts.length)
        data_count = Base.encode_compact_u16(instruction.data.length)

        instruction_layout.serialize({
          program_id_index: instruction.program_id_index,
          key_indices_count: key_indices_count,
          key_indices: instruction.accounts,
          data_length: data_count,
          data: instruction.data
        })
      end.flatten

      sign_data += data
    end

    def to_hash
      message = {
        account_keys:     account_keys,
        header:           header.to_h,
        instructions:     instructions.map(&:to_h),
        recent_blockhash: recent_blockhash
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
