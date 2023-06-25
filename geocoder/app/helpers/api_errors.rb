# frozen_string_literal: true

module ApiErrors
  def error_response(error_messages)
    ErrorSerializer.from_messages(error_messages)
  end
end
