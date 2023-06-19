# frozen_string_literal: true

require 'spec_helper'

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/environment'

abort('You run tests in production mode. Please don\'t do this!') if App.production?
Dir[[App.opts[:root], 'spec/support/**/*.rb'].join('/')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RouteHelpers, type: :request
  config.include(
    Module.new do
      def app
        App.freeze.app
      end
    end
  )
  config.include ClientHelpers, type: :client

  config.around do |example|
    Sequel::Model.db.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
