# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /signup' do
    let(:params) { attributes_for(:user) }

    context 'when success' do
      it 'returns 201 status' do
        post '/v1/signup', params

        expect(response.status).to eq(201)
      end
    end

    context 'when failure' do
      context 'when email is empty' do
        it 'returns :email error' do
          post '/v1/signup', params.merge(email: '')

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Email is missing',
              'source' => { 'pointer' => '/data/attributes/email' }
            }
          )
        end
      end

      context 'when name is missing' do
        it 'returns :missing_params error' do
          post '/v1/signup', params.except(:name)

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Request lacks necessary parameters'
            }
          )
        end
      end

      context 'when name format is invalid' do
        it 'returns :name error' do
          post '/v1/signup', params.merge(name: '-')

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Wrong name format',
              'source' => { 'pointer' => '/data/attributes/name' }
            }
          )
        end
      end
    end
  end
end
