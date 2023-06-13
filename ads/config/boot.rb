# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])
