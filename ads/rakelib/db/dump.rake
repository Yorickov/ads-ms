# frozen_string_literal: true

namespace :db do
  desc 'Dump database schema'
  task :dump do
    sh %(pg_dump --schema-only --no-privileges --no-owner -s ads_development > db/structure.sql)
  end
end
