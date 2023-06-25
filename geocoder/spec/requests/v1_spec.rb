# frozen_string_literal: true

RSpec.describe 'Geocoder API', type: :request do
  describe 'GET /v1' do
    before { stub_const("#{described_class}::DATA_PATH", "#{fixture_path}/city.csv") }
    context 'when success' do
      let(:params) { { city: 'City 17' } }

      it 'returns 201 status and correct data' do
        get '/v1', params

        expect(response.status).to eq(200)
        expect(json_response['data']).to include(
          {
            'lat' => 45.05,
            'lon' => 90.05
          }
        )
      end
    end

    context 'when failure' do
      context 'when city not found' do
        let(:params) { { city: 'wrong' } }

        it 'returns not_fond error' do
          get '/v1', params

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Resource not found'
            }
          )
        end
      end

      context 'when :city is missing' do
        it 'returns 422 with error' do
          get '/v1'

          expect(response.status).to eq(422)
          expect(json_response['errors']).to include(
            {
              'detail' => 'Request lacks necessary parameters'
            }
          )
        end
      end
    end
  end
end
