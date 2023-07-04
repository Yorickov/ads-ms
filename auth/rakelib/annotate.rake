# frozen_string_literal: true

desc 'Update model annotations'
task :annotate  => :settings do
  require 'sequel/core'
  require 'sequel/annotate'

  db = Sequel.connect(Config.db.to_h)
  dir_path = Dir[File.expand_path('../app/models/**/*.rb', __dir__)]
  dir_path.sort.each { |f| require f }
  Sequel::Annotate.annotate(dir_path)
  db.disconnect
end
