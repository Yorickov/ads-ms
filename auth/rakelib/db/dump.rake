# frozen_string_literal: true

namespace :db do
  desc 'Dump database schema'
  task dump: :settings do
    # sh %(pg_dump --schema-only --no-privileges --no-owner -s ads_development > db/structure.sql)
    require 'sequel/core'
    Sequel.extension :migration
    filepath = File.expand_path('../../db/schema.rb', __dir__)
    Sequel.connect(Config.db.to_h) do |db|
      db.extension :schema_dumper
      File.write(filepath, db.dump_schema_migration(same_db: true, foreign_keys: true, indexes: true))
    end
  end
end
