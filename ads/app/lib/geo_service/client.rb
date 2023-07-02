# frozen_string_literal: true

require_relative 'api'

module GeoService
  class Client < BaseClient
    include Api

    option :url, default: proc { Config.app.url['geocoder'] }
  end
end
