# frozen_string_literal: true

require 'yaml'
require 'sequel/core'

DB = Sequel.connect(
  YAML.safe_load(File.read(File.expand_path('database.yml', __dir__)), aliases: true)[ENV['RACK_ENV']]
)
