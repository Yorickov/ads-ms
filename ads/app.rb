# frozen_string_literal: true

require_relative 'config/init'

class App < Roda
  include ResponseHelper
  include PaginationLinks

  opts[:root] = File.expand_path(__dir__)

  plugin :environments

  plugin :default_headers, 'Content-Type' => 'application/json'
  plugin :all_verbs
  plugin :halt
  plugin :path
  plugin :json_parser
  # replaced with custom serializer
  # plugin :json, classes: [Array, Hash, Sequel::Model], content_type: 'application/json'

  plugin :symbolized_params
  plugin :i18n, locale: ['en'], translations: [File.expand_path('config/i18n', __dir__)]

  configure :development, :production do
    plugin :enhanced_logger
  end

  plugin :error_handler do |e|
    if e.instance_of?(KeyError)
      errors = error_response(t.errors.invalid_parameters(e.message))
      response.status = 422
    elsif e.instance_of?(Sequel::NoMatchingRow)
      errors = error_response(t.errors.not_found(e.message))
      response.status = 404
    elsif e.instance_of?(Sequel::ValidationFailed)
      errors = error_response(e.model)
      response.status = 422
    else
      errors = error_response(t.errors.unexpected_error(e.message))
      response.status = 500
    end

    response.write(errors.to_json)
  end

  route do |r|
    r.root do
      page = params[:page]&.to_i || DEFAULT_FIRST_PAGE
      ads = Ad.reverse_order(:updated_at)
              .paginate(page, DEFAULT_LIMIT)
      AdSerializer.new(ads.all, links: pagination_links(ads, r.path)).serializable_hash.to_json
    end

    r.on 'ads' do
      r.post do
        result = Ads::CreateService.call(**params)
        response.status = 201
        AdSerializer.new(result.ad).serializable_hash.to_json
      end
    end
  end
end
