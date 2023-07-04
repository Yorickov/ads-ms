# frozen_string_literal: true

module AdsService
  module HttpApi
    def update_coordinates(id, coordinates)
      connection.patch do |request|
        request.params = { id: id, coordinates: coordinates }
      end
    end
  end
end
