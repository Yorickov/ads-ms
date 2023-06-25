# frozen_string_literal: true

module GeoService
  module Api
    def coordinates(city)
      response = connection.get do |request|
        request.params['city'] = city
      end

      response.body['data'] if response.success?
    end
  end
end
