# frozen_string_literal: true

class App
  hash_branch 'v1' do |r|
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
