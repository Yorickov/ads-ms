# frozen_string_literal: true

Sequel.connect(Config.db.to_h)

Sequel::Model.db.extension(:pagination)
Sequel.default_timezone = :utc

Sequel::Model.plugin :require_valid_schema
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
  require 'logger'
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::FATAL if ENV['RACK_ENV'] == 'test'
  Sequel::Model.db.loggers << LOGGER
end
