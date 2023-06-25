# frozen_string_literal: true

require_relative 'api'

module GeoService
  class Client < BaseClient
    include Api

    option :url, default: proc { 'http://localhost:3020/v1' }
  end
end
