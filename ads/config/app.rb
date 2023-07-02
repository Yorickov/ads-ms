# frozen_string_literal: true

class App < Roda
  include ApiErrors
  include PaginationLinks
  include Validations
  include Auth

  opts[:root] = File.expand_path('..', __dir__)

  plugin :environments

  plugin :default_headers, 'Content-Type' => 'application/json'
  plugin :all_verbs
  plugin :json_parser
  plugin :request_headers
  # replaced with custom serializer
  # plugin :json, classes: [Array, Hash, Sequel::Model], content_type: 'application/json'

  plugin :symbolized_params
  plugin :hash_branches

  configure :development, :production do
    plugin :enhanced_logger
  end

  plugin :error_handler do |e|
    if e.instance_of?(KeyError) || e.instance_of?(Validations::InvalidParamsError)
      errors = error_response(::I18n.t('api.errors.missing_parameters', msg: e.message))
      response.status = 422
    elsif e.instance_of?(Sequel::NoMatchingRow)
      errors = error_response(::I18n.t('api.errors.not_found'))
      response.status = 404
    elsif e.instance_of?(Sequel::UniqueConstraintViolation)
      errors = error_response(::I18n.t('api.errors.not_unique'))
      response.status = 404
    elsif e.instance_of?(Auth::Unauthorized)
      errors = error_response(::I18n.t('api.errors.unauthorized'))
      response.status = 403
    else
      errors = error_response(::I18n.t('api.errors.unexpected_error', msg: e.message))
      response.status = 500
    end

    response.write(errors.to_json)
  end

  route do |r|
    r.hash_branches
  end
end
