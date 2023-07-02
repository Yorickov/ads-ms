# frozen_string_literal: true

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
    attr_config page_size: 10
    attr_config :url
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
