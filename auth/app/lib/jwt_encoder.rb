# frozen_string_literal: true

module JwtEncoder
  extend self

  HMAC_SECRET = Config.app.secret

  def encode(payload)
    JWT.encode(payload, HMAC_SECRET)
  end

  def decode(token)
    JWT.decode(token, HMAC_SECRET).first
  end
end
