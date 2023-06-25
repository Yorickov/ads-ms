# frozen_string_literal: true

require 'dry/initializer'

class BaseClient
  extend Dry::Initializer[undefined: false]

  option :url
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
