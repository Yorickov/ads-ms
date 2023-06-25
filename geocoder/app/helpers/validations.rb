# frozen_string_literal: true

module Validations
  class InvalidParamsError < StandardError; end

  def validate_with!(validation_contract)
    result = validate_with(validation_contract)
    raise InvalidParamsError if result.failure?

    result
  end

  def validate_with(validation_contract)
    contract = validation_contract.new
    contract.call(params)
  end
end
