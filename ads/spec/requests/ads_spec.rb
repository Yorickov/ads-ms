# frozen_string_literal: true

require 'spec_helper'

describe 'GET /ads/v1', type: :request do
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

describe 'POST /ads/v1', type: :request do
  let(:user_id) { 1 }
  let(:ad_params) { attributes_for(:ad) }

  context 'when success' do
    before do
      post '/ads/v1', ad: ad_params, user_id: user_id
    end

    it 'returns 201 status' do
      expect(response.status).to eq(201)
    end

    it 'returns correct json' do
      expect(json_response.dig('data', 'id')).to eq Ad.last.id.to_s
    end
  end

  context 'when failure' do
    context 'when param is invalid' do
      it 'returns InvalidParamsError' do
        post '/ads/v1', ad: ad_params.merge(city: ''), user_id: user_id

        expect(response.status).to eq(422)
        expect(json_response['errors']).to include(
          {
            'detail' => 'City is missing',
            'source' => { 'pointer' => '/data/attributes/city' }
          }
        )
      end
    end

    context 'when param is missing' do
      it 'returns InvalidParamsError' do
        post '/ads/v1', ad: ad_params.except(:city), user_id: user_id

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
