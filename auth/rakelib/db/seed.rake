# frozen_string_literal: true

namespace :db do
  desc 'Database seed'
  task seed: :settings do
    require 'sequel/core'
    require 'sequel/extensions/seed'
    Sequel.extension :seed
    Sequel::Seed.setup(ENV['RACK_ENV'])

    Sequel.connect(Config.db.to_h) do |db|
      seeds_path = File.expand_path('../../db/seeds', __dir__)
      Sequel::Seeder.apply(db, seeds_path)
    end
  end
end
