# frozen_string_literal: true

module RouteHelpers
  def response
    last_response
  end

  def json_response
    JSON.parse(response.body)
  end

  def fixture_path
    File.expand_path('../fixtures/city.csv', __dir__)
  end
end
