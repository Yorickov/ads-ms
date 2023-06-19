# frozen_string_literal: true

namespace :db do
  desc 'Create database'
  task :create => :settings do
    puts 'Creating database'
    create_db(Config.db.to_h)
    puts 'Database created'
  end
end

class << self
  def create_db(config)
    arguments = []
    arguments << "--host=#{Config.db.host}" if Config.db&.host
    arguments << Config.db.database

    Process.wait Process.spawn({}, 'createdb', *arguments)
  end
end
