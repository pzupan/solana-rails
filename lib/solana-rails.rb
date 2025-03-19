# frozen_string_literal: true

require_relative 'solana-rails/keypair'
require_relative 'solana-rails/base'
require_relative 'solana-rails/client'
require_relative "solana-rails/version"

module Solana
  module Rails
    class Error < StandardError; end
    # Your code goes here...
  end
end
