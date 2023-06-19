# frozen_string_literal: true

namespace :db do
  desc 'Dump database schema'
  task :dump do
    dev = ENV['RACK_ENV'] == 'development'
    sh %(pg_dump --schema-only --no-privileges --no-owner -s ads_development > db/structure.sql) if dev
  end
end
