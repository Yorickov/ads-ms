# frozen_string_literal: true

require 'csv'

module Geocoder
  class NotFoundError < StandardError; end

  extend self

  DATA_PATH = App.root.concat('/db/data/city.csv')

  def geocode(city)
    data[city]
  end

  def data
    @data ||= load_data!
  end

  private

  def load_data!
    @data = CSV.read(DATA_PATH, headers: true).each_with_object({}) do |row, result|
      city = row['city']
      lat = row['geo_lat'].to_f
      lon = row['geo_lon'].to_f
      result[city] = [lat, lon]
    end
  end
end
