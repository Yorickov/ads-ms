# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Sessions API', type: :request do
  describe 'POST /login' do
    let(:email) { 'bob@example.com' }
    let(:password) { 'givemeatoken' }
    let(:params) { { email: email, password: password } }
    let(:token) { 'jwt_token' }

    before do
      create(:user, **params)

      allow(JWT).to receive(:encode).and_return(token)
    end

    context 'when success' do
      it 'returns 201 status' do
        post '/v1/login', params

        expect(response.status).to eq(201)
        expect(json_response['meta']).to eq('token' => token)
      end
    end

    context 'when failure' do
      context 'when email is empty' do
        it 'returns :invalid_session error' do
          post '/v1/login', params.merge(email: '')

          expect(response.status).to eq(401)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Session can be created'
            }
          )
        end
      end

      context 'when email is missing' do
        it 'returns :missing_params error' do
          post '/v1/login', params.except(:email)

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Request lacks necessary parameters'
            }
          )
        end
      end

      context 'when password is invalid' do
        it 'returns :invalid_session error' do
          post '/v1/login', params.merge(password: 'wrong')

          expect(response.status).to eq(401)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Session can be created'
            }
          )
        end
      end
    end
  end
end
