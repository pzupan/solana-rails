module SolanaRails
  
  class TransactionInstruction

    def initialize(**args)
      @keys                        = args[:keys]
      @system_keys                 = args[:system_keys]
      @token_program_id            = args[:token_program_id]
      @associated_token_program_id = args[:associated_token_program_id]
      @recent_blockhash            = args[:recent_blockhash]
      @data                        = args[:data]

      error_check_keys
      error_check_recent_blockhash
    end

    # use ordered_keys to get the correct sequence
    def keys
      @keys.map{ |d| JSON.parse(d.to_json, object_class: OpenStruct) }
    end

    def system_keys
      @system_keys.map{ |d| JSON.parse(d.to_json, object_class: OpenStruct) }
    end

    # arrange keys in correct order
    def ordered_keys
      keys_arr = keys.select{ |k| k.is_signer && k.is_writable }
      keys_arr + keys.select{ |k| k.is_signer && !k.is_writable }
      keys_arr + keys.select{ |k| !k.is_signer && k.is_writable }
      keys_arr + keys.select{ |k| !k.is_signer && !k.is_writable }
    end

    def account_keys
      ordered_keys.map{ |k| k.pubkey } + [ token_program_id ] + system_keys.map{ |k| k.pubkey }
    end

    def header
      {
        num_readonly_signed_accounts: count_read_only_signed_accounts,
        num_readonly_unsigned_accounts: count_read_only_unsigned_accounts,
        num_required_signatures: count_required_signatures
      }
    end

    def token_program_id
      @token_program_id
    end

    def associated_token_program_id
      @associated_token_program_id
    end

    def recent_blockhash
      @recent_blockhash
    end

    def data
      @data.map{ |d| JSON.parse(d.to_json, object_class: OpenStruct) }
    end

    def instructions
      [{
        accounts: accounts_to_pass_to_program,
        data: data,
        program_id_index: token_program_id_index,
        stackHeight: nil,
      }]
    end

    def to_json
      transaction_instruction = {
        keys: ordered_keys.map{ |k| k.to_h },
        recent_blockhash: recent_blockhash,
        data: data.map{ |d| d.to_h }
      }
      transaction_instruction[:token_program_id] = token_program_id if token_program_id.present?
      transaction_instruction[:associated_token_program_id] if associated_token_program_id.present?
      transaction_instruction.to_json
    end

    protected

    def count_required_signatures
      ordered_keys.count{ |k| k.is_signer && k.is_writable }
    end

    def count_read_only_signed_accounts
      ordered_keys.count{ |k| k.is_signer && !k.is_writable }
    end

    def count_read_only_unsigned_accounts
      ordered_keys.count{ |k| !k.is_signer && !k.is_writable } + system_keys.length
    end

    def token_program_id_index
      account_keys.index(token_program_id)
    end

    def accounts_to_pass_to_program
      (0..ordered_keys.length).to_a
    end

    def error_check_keys
      raise 'must_include_keys' if @keys.blank?
      keys.each do |key|
        raise "key_must_include_pubkey: #{key}" if key.try(:pubkey).nil?
        raise "key_must_include_is_signer #{key.pubkey}" if key.try(:is_signer).nil?
        raise "key_must_include_is_writer #{key.pubkey}" if key.try(:is_writable).nil?
      end

      raise 'keys_pubkeys_must_be_unique' unless keys.uniq{ |k| k.pubkey }.length == keys.length
    end

    def error_check_recent_blockhash
      raise 'must_include_recent_blockhash' if recent_blockhash.blank?
    end

  end
end
