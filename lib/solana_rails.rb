# frozen_string_literal: true

require_relative 'solana_rails/base'
require_relative 'solana_rails/client'
require_relative 'solana_rails/data_types'
require_relative 'solana_rails/keypair'
require_relative "solana_rails/version"

require_relative 'solana_rails/models/message'
require_relative 'solana_rails/models/transaction'
require_relative 'solana_rails/models/transaction_instruction'

require_relative 'solana_rails/token/transaction_helpers'

module SolanaRails
  class Error < StandardError; end
end
