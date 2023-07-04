# frozen_string_literal: true

require_relative 'rpc_api'

module AdsService
  class HttpClient
    extend Dry::Initializer[undefined: false]
    include HttpApi

    option :url, default: proc { Config.app.url['ads'] }
    option :connection, default: proc { build_connection }

    private

    def build_connection
      Faraday.new(@url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
