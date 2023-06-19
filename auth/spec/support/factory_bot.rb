# frozen_string_literal: true

FactoryBot.define { to_create(&:save) }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
