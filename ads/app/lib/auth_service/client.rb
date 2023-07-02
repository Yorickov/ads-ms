# frozen_string_literal: true

require_relative 'api'

module AuthService
  class Client < BaseClient
    include Api

    option :url, default: proc { Config.app.url['auth'] }
  end
end
