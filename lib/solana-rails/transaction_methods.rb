module SolanaRails
  module TransactionMethods

    def send_transaction(transaction, options = {}, &block)
      request_http('sendTransaction', [transaction.to_json, options], &block)
    end

    def simulate_transaction(transaction, options = {}, &block)
      request_http('simulateTransaction', [transaction.to_json, options], &block)
    end

  end
end
