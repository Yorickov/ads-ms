# frozen_string_literal: true

Anyway::Settings.default_config_path = File.expand_path('..', __dir__)
Anyway::Settings.current_environment = ENV['RACK_ENV'] || 'development'

module Config
  class AppConfig < Anyway::Config
    config_name :app
    attr_config :rabbitmq
    attr_config :url
  end

  class << self
    def app
      @app ||= AppConfig.new
    end
  end
end
