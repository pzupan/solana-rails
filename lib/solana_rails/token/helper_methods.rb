require 'base58'
require 'rbnacl'

require_relative 'ed25519'

module SolanaRails
  module Token
    module HelperMethods

      include RbNaCl

      def self.get_associated_token_address(**args)
        mint_pubkey      = args[:mint_pubkey]
        owner_pubkey     = args[:owner_pubkey]
        token_program_id = args[:token_program_id] || SolanaRails::Base::TOKEN_PROGRAM_ID

        mint_bytes          = Base58.base58_to_binary(mint_pubkey, :bitcoin)
        owner_bytes         = Base58.base58_to_binary(owner_pubkey, :bitcoin)
        token_program_bytes = Base58.base58_to_binary(token_program_id, :bitcoin)

        seeds = [
          mint_bytes,
          owner_bytes,
          token_program_bytes
        ]

        associated_token_account_pubkey = find_program_address(seeds)

        Base58.binary_to_base58(associated_token_account_pubkey, :bitcoin)
      end

      private

      def self.find_program_address(seeds)
        nonce = 255

        puts "*** Find off curve token account address"
        loop do
          seeds_with_nonce = seeds + [[nonce].pack('C')]
          hashed_buffer = hash_seeds(seeds_with_nonce)

          puts "**** Testing nonce #{nonce}: #{Base58.binary_to_base58(hashed_buffer, :bitcoin)}"

          if !SolanaRails::Token::Ed25519.on_curve?(hashed_buffer)
            puts "**** Found with nonce #{nonce}: #{Base58.binary_to_base58(hashed_buffer, :bitcoin)}"
            return hashed_buffer
          end

          nonce -= 1
          raise "**** Unable to find a off curve address" if nonce < 0
        end
      end

      def self.hash_seeds(seeds)
        associated_token_program_id = SolanaRails::Base::ASSOCIATED_TOKEN_PROGRAM_ID
        buffer = seeds.flatten.join + associated_token_program_id + "ProgramDerivedAddress"
        RbNaCl::Hash.sha256(buffer)
      end

    end
  end
end
