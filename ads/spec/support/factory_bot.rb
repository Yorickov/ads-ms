# frozen_string_literal: true

require 'factory_bot'

FactoryBot.find_definitions
FactoryBot.define { to_create(&:save) }
FactoryBot.use_parent_strategy = false

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
