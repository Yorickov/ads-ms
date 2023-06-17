# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Sessions API', type: :request do
  describe 'GET /auth' do
    let(:user) { create(:user) }
    let(:session) { create(:user_session, user: user) }
    let(:uuid) { session.uuid }
    let(:token) { "Bearer #{JwtEncoder.encode(uuid: session.uuid)}" }

    context 'when success' do
      it 'returns 200 status' do
        header 'Authorization', token
        get '/v1/auth'

        expect(response.status).to eq(200)
        expect(json_response['meta']).to eq('user_id' => user.id)
      end
    end

    context 'when failure' do
      context 'when auht token invalid' do
        let(:token) { 'Bearer token' }

        it 'returns 403 error' do
          header 'Authorization', token
          get '/v1/auth'

          expect(response.status).to eq(403)
          expect(json_response['errors']).to include(
            {
              'detail' => 'No permission to access the resource'
            }
          )
        end
      end

      context 'when auth header is missing' do
        it 'returns 403 error' do
          get '/v1/auth'

          expect(response.status).to eq(403)
          expect(json_response['errors']).to include(
            {
              'detail' => 'No permission to access the resource'
            }
          )
        end
      end
    end
  end
end
