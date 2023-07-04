# frozen_string_literal: true

Anyway::Settings.default_config_path = File.expand_path('..', __dir__)
Anyway::Settings.current_environment = ENV['RACK_ENV'] || 'development'

module Config
  class DatabaseConfig < Anyway::Config
    config_name :database
    attr_config :database,
                :max_connections,
                adapter: 'postgresql',
                encoding: 'unicode',
                host: 'localhost'
  end

  class AppConfig < Anyway::Config
    config_name :app
    attr_config secret: 'some'
    attr_config :rabbitmq
  end

  class << self
    def db
      @db ||= DatabaseConfig.new
    end

    def app
      @app ||= AppConfig.new
    end
  end
end
