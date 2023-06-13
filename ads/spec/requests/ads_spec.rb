# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'GET /', type: :request do
  let(:user_id) { 1 }

  before do
    create_list(:ad, 2, user_id: user_id)
    get '/'
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

describe 'POST /ads', type: :request do
  let(:user_id) { 1 }
  let(:ad_params) { attributes_for(:ad) }

  context 'when success' do
    before do
      post '/ads', ad: ad_params, user_id: user_id
    end

    it 'returns 201 status' do
      expect(response.status).to eq(201)
    end

    it 'returns correct json' do
      expect(json_response.dig('data', 'id')).to eq Ad.last.id.to_s
    end
  end

  context 'when failure' do
    context 'when param is missing' do
      it 'returns KeyError' do
        post '/ads', ad: ad_params.except(:city), user_id: user_id

        expect(response.status).to eq(422)
        expect(json_response['errors']).to include(
          {
            'detail' => "Request lacks necessary parameters: Ads::CreateService::Ad: option 'city' is required"
          }
        )
      end
    end

    context 'when param is empty' do
      it 'returns :param error' do
        post '/ads', ad: ad_params.merge(city: ''), user_id: user_id

        expect(response.status).to eq(422)
        expect(json_response['errors']).to include(
          {
            'detail' => 'is not present',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end
  end
end
