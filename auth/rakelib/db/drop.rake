# frozen_string_literal: true

namespace :db do
  desc 'Drop database'
  task :drop => :settings do
    puts 'Dropping database'
    drop_db(Config.db.to_h)
    puts 'Database droped'
  end
end

class << self
  def drop_db(config)
    arguments = []
    arguments << "--host=#{Config.db.host}" if Config.db&.host
    arguments << Config.db.database

    Process.wait Process.spawn({}, 'dropdb', *arguments)
  end
end
