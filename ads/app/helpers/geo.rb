# frozen_string_literal: true

module Geo
  def coordinates(city)
    geo_service.coordinates(city)
  end

  private

  def geo_service
    @geo_service ||= GeoService::Client.new
  end
end
