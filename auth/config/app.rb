# frozen_string_literal: true

class App < Roda
  include ApiErrors
  include Validations
  include Auth

  opts[:root] = File.expand_path('..', __dir__)

  plugin :environments

  plugin :default_headers, 'Content-Type' => 'application/json'
  plugin :all_verbs
  plugin :json_parser
  plugin :request_headers
  plugin :symbolized_params

  configure :development, :production do
    plugin :enhanced_logger
  end

  plugin :error_handler do |e|
    if e.instance_of?(KeyError) || e.instance_of?(Validations::InvalidParamsError)
      errors = error_response(::I18n.t('api.errors.missing_parameters', msg: e.message))
      response.status = 422
    elsif e.instance_of?(Sequel::NoMatchingRow)
      errors = error_response(::I18n.t('api.errors.not_found', msg: e.message))
      response.status = 404
    elsif e.instance_of?(Sequel::UniqueConstraintViolation)
      errors = error_response(::I18n.t('api.errors.not_unique'))
      response.status = 404
    else
      errors = error_response(::I18n.t('api.errors.unexpected_error', msg: e.message))
      response.status = 500
    end

    response.write(errors.to_json)
  end

  route do |r|
    r.on 'v1' do
      r.on 'signup' do
        r.post true do
          users_params = validate_with!(UserParamsContract)
          result = Users::CreateService.call(*users_params.to_h.values)

          if result.success?
            response.status = 201
            response.write(nil)
          else
            response.status = 422
            error_response(result.user).to_json
          end
        end
      end

      r.on 'login' do
        r.post true do
          session_params = validate_with!(SessionParamsContract)
          result = UserSessions::CreateService.call(*session_params.to_h.values)

          if result.success?
            token = JwtEncoder.encode(uuid: result.session.uuid)
            response.status = 201
            { meta: { token: token } }.to_json
          else
            response.status = 401
            error_response(result.session || result.errors).to_json
          end
        end
      end

      r.on 'auth' do
        r.post true do
          result = Auth::FetchUserService.call(extracted_token['uuid'])
          if result.success?
            response.status = 200
            { meta: { user_id: result.user.id } }.to_json
          else
            response.status = 403
            error_response(result.errors).to_json
          end
        end
      end
    end
  end
end
