# frozen_string_literal: true

class AdSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :city, :lat, :lon
end
