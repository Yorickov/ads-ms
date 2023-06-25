# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'GET /ads/v1', type: :request do
  let(:user_id) { 1 }

  before do
    create_list(:ad, 2, user_id: user_id)
    get '/ads/v1'
  end

  it 'returns 200 HTTP status' do
    expect(response.status).to eq 200
  end

  it 'returns OK in the response body' do
    ads, links = json_response.values_at('data', 'links')

    expect(ads.size).to eq 2
    expect(links['first']).to match '/?page=1'
  end
end

RSpec.describe 'POST /ads/v1', type: :request do
  let(:user_id) { 1 }
  let(:geo_data) {
    {
      'lat' => 45.05,
      'lon' => 90.05
    }
  }
  let(:ad_params) { attributes_for(:ad) }
  let(:auth_token) { 'auth.token' }
  let(:auth_service) { instance_double('Auth service') }
  let(:geo_service) { instance_double('Geo service') }

  before do
    allow(auth_service)
      .to receive(:auth)
      .and_return(user_id)
    allow(AuthService::Client)
      .to receive(:new)
      .and_return(auth_service)

    allow(geo_service)
      .to receive(:coordinates)
      .and_return(geo_data)
    allow(GeoService::Client)
      .to receive(:new)
      .and_return(geo_service)

    header 'Authorization', "Bearer #{auth_token}"
  end

  context 'when success' do
    before do
      post '/ads/v1', ad: ad_params
    end

    it 'returns 201 status' do
      expect(response.status).to eq(201)
    end

    it 'returns correct json' do
      expect(json_response.dig('data', 'id')).to eq Ad.last.id.to_s
    end
  end

  context 'when failure' do
    context 'when city is invalid' do
      it 'returns :city error' do
        post '/ads/v1', ad: ad_params.merge(city: '')

        expect(response.status).to eq(422)
        expect(json_response['errors']).to include(
          {
            'detail' => 'City is missing',
            'source' => { 'pointer' => '/data/attributes/city' }
          }
        )
      end
    end

    context 'when city is missing' do
      it 'returns :city error' do
        post '/ads/v1', ad: ad_params.except(:city)

        expect(response.status).to eq(422)
        expect(json_response['errors']).to include(
          {
            'detail' => 'Request lacks necessary parameters'
          }
        )
      end
    end

    context 'when user_id is missing ' do
      let(:user_id) { nil }

      it 'returns an error' do
        post '/ads/v1', ad: ad_params

        expect(response.status).to eq(403)
        expect(json_response['errors']).to include('detail' => 'No permission to access the resource')
      end
    end
  end
end
