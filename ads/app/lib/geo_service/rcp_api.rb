# frozen_string_literal: true

module GeoService
  module RcpApi
    def geocode_later(ad)
      payload = { id: ad.id, city: ad.city }.to_json
      publish(payload, type: 'geocode')
    end
  end
end
