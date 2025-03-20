module SolanaRails
  module HttpMethods

    def get_account_info(pubkey, options = {}, &block)
      request_http('getAccountInfo', [pubkey, options], &block)
    end

    def get_balance(pubkey, options = {}, &block)
      request_http('getBalance', [pubkey, options], &block)
    end

    def get_block(slot_number, options = {}, &block)
      request_http('getBlock', [slot_number, options], &block)
    end

    def get_block_commitment(slot_number, options = {}, &block)
      request_http('getBlockCommitment', [slot_number, options], &block)
    end

    def get_block_height(options = {}, &block)
      request_http('getBlockHeight', [options], &block)
    end

    def get_block_production(options = {}, &block)
      request_http('getBlockProduction', [options], &block)
    end

    def get_block_time(slot_number, &block)
      request_http('getBlockTime', [slot_number], &block)
    end

    def get_blocks(start_slot, options = {}, &block)
      request_http('getBlocks', [start_slot, options], &block)
    end

    def get_blocks_with_limit(start_slot, limit, options = {}, &block)
      request_http('getBlocksWithLimit', [start_slot, limit, options], &block)
    end

    def get_cluster_nodes(&block)
      request_http('getClusterNodes', &block)
    end

    def get_epoch_info(options = {}, &block)
      request_http('getEpochInfo', [options], &block)
    end

    def get_epoch_schedule(&block)
      request_http('getEpochSchedule', &block)
    end

    def get_fee_for_message(message, options = {}, &block)
      request_http('getFeeForMessage', [message, options], &block)
    end

    def get_first_available_block(&block)
      request_http('getFirstAvailableBlock', &block)
    end

    def get_genesis_hash(&block)
      request_http('getGenesisHash', &block)
    end

    def get_health(&block)
      request_http('getHealth', &block)
    end

    def get_highest_snapshot_slot(&block)
      request_http('getHighestSnapshotSlot', &block)
    end

    def get_identity(&block)
      request_http('getIdentity', &block)
    end

    def get_inflation_governor(options = {}, &block)
      request_http('getInflationGovernor', [options], &block)
    end

    def get_inflation_rate(&block)
      request_http('getInflationRate', &block)
    end

    def get_inflation_reward(addresses, options = {}, &block)
      request_http('getInflationReward', [addresses, options], &block)
    end

    def get_largest_accounts(options = {}, &block)
      request_http('getLargestAccounts', [options], &block)
    end

    def get_latest_blockhash(options = {}, &block)
      request_http('getLatestBlockhash', [options], &block)
    end

    def get_leader_schedule(slot_number = nil, options = {}, &block)
      request_http('getLeaderSchedule', [slot_number, options], &block)
    end

    def get_max_retransmit_slot(&block)
      request_http('getMaxRetransmitSlot', &block)
    end

    def get_max_shred_insert_slot(&block)
      request_http('getMaxShredInsertSlot', &block)
    end

    def get_minimum_balance_for_rent_exemption(data_length, options = {}, &block)
      request_http('getMinimumBalanceForRentExemption', [data_length, options], &block)
    end

    def get_multiple_accounts(pubkeys, options = {}, &block)
      request_http('getMultipleAccounts', [pubkeys, options], &block)
    end

    def get_program_accounts(pubkey, options = {}, &block)
      request_http('getProgramAccounts', [pubkey, options], &block)
    end

    def get_recent_performance_samples(limit = 720, options = {}, &block)
      request_http('getRecentPerformanceSamples', [limit, options], &block)
    end

    def get_recent_prioritization_fees(addresses = [], &block)
      request_http('getRecentPrioritizationFees', [addresses], &block)
    end

    def get_signature_statuses(signatures, options = {}, &block)
      request_http('getSignatureStatuses', [signatures, options], &block)
    end

    def get_signatures_for_address(address, options = {}, &block)
      request_http('getSignaturesForAddress', [address, options], &block)
    end

    def get_slot(options = {}, &block)
      request_http('getSlot', [options], &block)
    end

    def get_slot_leader(options = {}, &block)
      request_http('getSlotLeader', [options], &block)
    end

    def get_slot_leaders(start_slot, limit, options = {}, &block)
      request_http('getSlotLeaders', [start_slot, limit, options], &block)
    end

    def get_stake_activation(pubkey, options = {}, &block)
      request_http('getStakeActivation', [pubkey, options], &block)
    end

    def get_stake_minimum_delegation(options = {}, &block)
      request_http('getStakeMinimumDelegation', [options], &block)
    end

    def get_supply(options = {}, &block)
      request_http('getSupply', [options], &block)
    end

    def get_token_account_balance(pubkey, options = {}, &block)
      request_http('getTokenAccountBalance', [pubkey, options], &block)
    end

    def get_token_accounts_by_delegate(delegate, opts = {}, options = {}, &block)
      request_http('getTokenAccountsByDelegate', [delegate, opts, options], &block)
    end

    def get_token_accounts_by_owner(owner, opts = {}, options = {}, &block)
      request_http('getTokenAccountsByOwner', [owner, opts, options], &block)
    end

    def get_token_largest_accounts(pubkey, options = {}, &block)
      request_http('getTokenLargestAccounts', [pubkey, options], &block)
    end

    def get_token_supply(pubkey, options = {}, &block)
      request_http('getTokenSupply', [pubkey, options], &block)
    end

    def get_transaction(signature, options = {}, &block)
      request_http('getTransaction', [signature, options], &block)
    end

    def get_transaction_count(options = {}, &block)
      request_http('getTransactionCount', [options], &block)
    end

    def get_version(&block)
      request_http('getVersion', &block)
    end

    def get_vote_accounts(options = {}, &block)
      request_http('getVoteAccounts', [options], &block)
    end

    def is_blockhash_valid(blockhash, options = {}, &block)
      request_http('isBlockhashValid', [blockhash, options], &block)
    end

    def minimum_ledger_slot(&block)
      request_http('minimumLedgerSlot', &block)
    end

    def request_airdrop(pubkey, lamports, options = {}, &block)
      request_http('requestAirdrop', [pubkey, lamports, options], &block)
    end

    def send_transaction(transaction, options = {}, &block)
      request_http('sendTransaction', [transaction.to_json, options], &block)
    end

    def simulate_transaction(transaction, options = {}, &block)
      request_http('simulateTransaction', [transaction.to_json, options], &block)
    end

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
