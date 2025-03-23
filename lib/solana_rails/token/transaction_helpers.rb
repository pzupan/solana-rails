require_relative '../models/message'
require_relative '../models/transaction'
require_relative '../models/transaction_instruction'

module SolanaRails
  module Token

    class TransactionHelpers

       def self.create_associated_token_account(**args)
        payer_pubkey = args[:payer_pubkey]
        ata_pubkey = args[:ata_pubkey]
        mint_pubkey = args[:mint_pubkey]
        owner_pubkey = args[:owner_pubkey]
        recent_blockhash = args[:recent_blockhash]
        token_program_id = args[:token_program_id] || SolanaRails::Base::TOKEN_PROGRAM_ID

        associated_token_program_id = SolanaRails::Base::ASSOCIATED_TOKEN_PROGRAM_ID
        system_program_id           = SolanaRails::Base::SYSTEM_PROGRAM_ID
        sysvar_rent_id              = SolanaRails::Base::SYSVAR_RENT_ID

        if @ata_pubkey.blank?
          # Derive the associated token account address
          ata_pubkey = SolanaRails::Token::HelperMethods.get_associated_token_address(
            mint_pubkey: mint_pubkey,
            owner_pubkey: owner_pubkey,
            token_program_id: token_program_id
          )
          puts "*** Using ATA pubkey: #{ata_pubkey}"
        end

        transaction_instruction = SolanaRails::TransactionInstruction.new(
          keys: [
            { pubkey: payer_pubkey, is_signer: true,  is_writable: true },
            { pubkey: ata_pubkey,   is_signer: false, is_writable: true },
            { pubkey: owner_pubkey, is_signer: false, is_writable: false },
            { pubkey: mint_pubkey,  is_signer: false, is_writable: false }
          ],
          system_keys: [
            { pubkey: system_program_id, is_signer: false, is_writable: false },
            { pubkey: sysvar_rent_id,    is_signer: false, is_writable: false }
          ],
          token_program_id: token_program_id,
          associated_token_program_id: associated_token_program_id,
          recent_blockhash: recent_blockhash,
          data: []
        )

        puts ''
        puts "**** Transaction Instruction: #{transaction_instruction.to_json}"
        puts ''

        message = SolanaRails::Message.from_transaction_instruction(transaction_instruction)

        puts "**** Message: #{message.to_json}"
        puts ''

        SolanaRails::Transaction.from_message(message)
      end

    end

  end
end
