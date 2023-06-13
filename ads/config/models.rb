# frozen_string_literal: true

require_relative 'db'
require 'sequel/model'

Sequel::Model.cache_associations = false if ENV['RACK_ENV'] == 'development'
Sequel::Model.db.extension(:pagination)
Sequel.default_timezone = :utc

Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :require_valid_schema
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
  require 'logger'
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::FATAL if ENV['RACK_ENV'] == 'test'
  DB.loggers << LOGGER
end
