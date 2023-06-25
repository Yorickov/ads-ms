# frozen_string_literal: true

class App < Roda
  include ApiErrors
  include Validations

  opts[:root] = File.expand_path('..', __dir__)

  plugin :environments

  plugin :default_headers, 'Content-Type' => 'application/json'
  plugin :all_verbs
  plugin :json_parser
  plugin :json, classes: [Array, Hash, Sequel::Model], content_type: 'application/json'
  plugin :symbolized_params

  configure :development, :production do
    plugin :enhanced_logger
  end

  plugin :error_handler do |e|
    if e.instance_of?(KeyError) || e.instance_of?(Validations::InvalidParamsError)
      errors = error_response(::I18n.t('api.errors.missing_parameters', msg: e.message))
      response.status = 422
    elsif e.instance_of?(Geocoder::NotFoundError)
      errors = error_response(::I18n.t('api.errors.not_found'))
      response.status = 422
    else
      errors = error_response(::I18n.t('api.errors.unexpected_error', msg: e.message))
      response.status = 500
    end

    response.write(errors.to_json)
  end

  route do |r|
    r.on 'v1' do
      r.get do
        geo_params = validate_with!(GeocoderParamsContract)
        result = Geocoder.geocode(geo_params[:city])
        raise Geocoder::NotFoundError if result.blank?

        response.status = 200
        { data: { lat: result[0], lon: result[1] } }
      end
    end
  end
end
