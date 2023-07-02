# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BasicService

    param :id
    param :lat
    param :lon
    option :ad, default: proc { Ad.first(id: @id) }

    def call
      return fail!(I18n.t('api.errors.not_found')) if @ad.nil?

      @ad.update_fields({ lat: lat, lon: lon }, %i[lat lon])
    end
  end
end
