# frozen_string_literal: true

require_relative 'config/environment'

App.freeze unless ENV['RACK_ENV'] == 'development'
run App.app
