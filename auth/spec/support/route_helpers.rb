# frozen_string_literal: true

module RouteHelpers
  def response
    last_response
  end

  def json_response
    JSON.parse(response.body)
  end
end
