# Solana::Rails

This is a Rails wrapper for the [Solana RPC API](https://solana.com/docs/rpc).


## Installation

Add this line to your application's Gemfile:

```bash
gem 'UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG'
```

And then execute:

```bash
    $ bundle install
```

Or install it yourself as:

```bash
    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

The default endpoint for the Solana::Rails.client is the Solana Mainnet. If you wish to connect to another network (Devnet or Testnet), you can specify the URL.

    require 'solana_rails'

    # Initialize the client (defaults to Mainnet(https://api.mainnet-beta.solana.com))
    client = SolanaRails::Client.new

    # Optionally, provide a network
    # client = SolanaRails::Client.new('devnet')

    # Then use the Solana RPC method (parameterized)
    client.get_balance(pubkey)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/solana-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/solana-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Solana::Rails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/solana-rails/blob/master/CODE_OF_CONDUCT.md).
