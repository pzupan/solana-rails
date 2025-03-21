# frozen_string_literal: true

require_relative 'solana-rails/base'
require_relative 'solana-rails/client'
require_relative 'solana-rails/keypair'
require_relative "solana-rails/version"

require_relative 'solana-rails/models/message'
require_relative 'solana-rails/models/transaction'
require_relative 'solana-rails/models/transaction_instruction'

require_relative 'solana-rails/token/transaction_helpers'

module SolanaRails
  class Error < StandardError; end

end
