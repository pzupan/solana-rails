module SolanaRails
  module WebsocketMethods

    def account_subscribe(pubkey, options = {}, &block)
      request_ws('accountSubscribe', [pubkey, options], &block)
    end

    def account_unsubscribe(subscription_id, &block)
      request_ws('accountUnsubscribe', [subscription_id], &block)
    end

    def block_subscribe(filter, options = {}, &block)
      request_ws('blockSubscribe', [filter, options], &block)
    end

    def block_unsubscribe(subscription_id, &block)
      request_ws('blockUnsubscribe', [subscription_id], &block)
    end

    def logs_subscribe(filter, options = {}, &block)
      request_ws('logsSubscribe', [filter, options], &block)
    end

    def logs_unsubscribe(subscription_id, &block)
      request_ws('logsUnsubscribe', [subscription_id], &block)
    end

    def program_subscribe(pubkey, options = {}, &block)
      request_ws('programSubscribe', [pubkey, options], &block)
    end

    def program_unsubscribe(subscription_id, &block)
      request_ws('programUnsubscribe', [subscription_id], &block)
    end

    def root_subscribe(&block)
      request_ws('rootSubscribe', &block)
    end

    def root_unsubscribe(subscription_id, &block)
      request_ws('rootUnsubscribe', [subscription_id], &block)
    end

    def signature_subscribe(signature, options = {}, &block)
      request_ws('signatureSubscribe', [signature, options], &block)
    end

    def signature_unsubscribe(subscription_id, &block)
      request_ws('signatureUnsubscribe', [subscription_id], &block)
    end

    def slot_subscribe(&block)
      request_ws('slotSubscribe', &block)
    end

    def slot_unsubscribe(subscription_id, &block)
      request_ws('slotUnsubscribe', [subscription_id], &block)
    end

    def slots_updates_subscribe(&block)
      request_ws('slotsUpdatesSubscribe', &block)
    end

    def slots_updates_unsubscribe(subscription_id, &block)
      request_ws('slotsUpdatesUnsubscribe', [subscription_id], &block)
    end

    def vote_subscribe(&block)
      request_ws('voteSubscribe', &block)
    end

    def vote_unsubscribe(subscription_id, &block)
      request_ws('voteUnsubscribe', [subscription_id], &block)
    end

  end
end
