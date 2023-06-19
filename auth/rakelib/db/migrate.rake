# frozen_string_literal: true

namespace :db do
  desc 'Run database migrations'
  task :migrate, %i[version] => :settings do |t, args|
    require 'sequel/core'
    require 'logger'

    Sequel.extension :migration

    Sequel.connect(Config.db.to_h) do |db|
      db.loggers << Logger.new($stdout) if db.loggers.empty?
      migrations = File.expand_path('../../db/migrate', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
    end
     Rake::Task['db:dump'].invoke
  end
end
