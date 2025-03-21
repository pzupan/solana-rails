# frozen_string_literal: true

require_relative "lib/solana-rails/version"

Gem::Specification.new do |spec|
  spec.name = "solana-rails"
  spec.version = SolanaRails::VERSION
  spec.authors = ["pzupan"]
  spec.email = ["pzupan@gmail.com"]

  spec.summary = "Solana Rails SDK."
  spec.description = "This is a Rails wrapper for the Solana RPC API."
  spec.homepage = "https://github.com/pzupan/solana-rails."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://www.rubydoc.info/gems/solana-rails"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httpx", "~> 1.4.2"
  spec.add_dependency "faye-websocket", "~> 0.11.3"
  spec.add_dependency 'base58', '~> 0.2.3'
  spec.add_dependency 'base64', '~> 0.2.0'
  spec.add_dependency 'rbnacl', '~> 7.1'
  #spec.add_dependency 'ed25519'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
