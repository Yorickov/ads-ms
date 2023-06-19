# frozen_string_literal: true

environment ENV.fetch('RACK_ENV', 'development')
port ENV.fetch('PORT', 3000)
