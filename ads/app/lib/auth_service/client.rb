# frozen_string_literal: true

require_relative 'api'

module AuthService
  class Client < BaseClient
    include Api

    option :url, default: proc { 'http://localhost:3010/v1' }
  end
end
