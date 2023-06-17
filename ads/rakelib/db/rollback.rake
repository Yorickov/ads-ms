# frozen_string_literal: true

namespace :db do
  desc 'Rollback to previous migration'
  task :rollback => :settings do
    require 'sequel/core'
    require 'logger'

    Sequel.extension :migration
    Sequel.connect(Config.db.to_h) do |db|
      db.loggers << Logger.new($stdout) if db.loggers.empty?
      current_version = db['SELECT * FROM schema_info'].first[:version]
      migrations = File.expand_path('../../db/migrate', __dir__)
      Sequel::Migrator.run(db, migrations, target: current_version - 1)
    end
     Rake::Task['db:dump'].invoke
  end
end
