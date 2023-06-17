# frozen_string_literal: true

module Auth
  AUTH_TOKEN = /\ABearer (?<token>.+)\z/.freeze

  def extracted_token
    JwtEncoder.decode(matched_token)
  rescue JWT::DecodeError
    {}
  end

  private

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.headers['Authorization']
  end
end
