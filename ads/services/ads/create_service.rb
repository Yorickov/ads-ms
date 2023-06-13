# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    attr_reader :ad

    def call
      @ad = ::Ad.new(ad.to_h)
      @ad.user_id = @user_id
      @ad.save
    end
  end
end
