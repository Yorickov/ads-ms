# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'

require_relative '../app'

Dir[[App.opts[:root], 'spec/support/**/*.rb'].join('/')].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include Rack::Test::Methods, type: :request
  config.include Helpers, type: :request
  config.include(
    Module.new do
      def app
        App.freeze.app
      end
    end
  )
  config.around do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
