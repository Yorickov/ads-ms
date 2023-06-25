# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    include Geo

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id
      @ad.lat, @ad.lon = coordinates(@ad.city).values_at('lat', 'lon')

      if @ad.valid?
        @ad.save
      else
        fail!(@ad.errors)
      end
    end
  end
end
