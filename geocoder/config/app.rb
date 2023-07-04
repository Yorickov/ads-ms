# frozen_string_literal: true

class App
  def self.root
    File.expand_path('..', __dir__)
  end

  def self.environment
    ENV.fetch('RACK_ENV').to_sym
  end
end
