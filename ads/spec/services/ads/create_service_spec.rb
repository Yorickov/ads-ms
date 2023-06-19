# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  let(:service_called) { described_class.call(**params) }

  let(:user_id) { 101 }

  context 'when success' do
    let(:params) {
      {
        ad: attributes_for(:ad),
        user_id: user_id
      }
    }

    it 'creates a new ad' do
      expect { service_called }.to change(Ad, :count).by(1)
    end

    it 'returns ad' do
      expect(service_called.ad).to be_a(Ad)
    end
  end

  context 'when failure' do
    let(:params) {
      {
        ad: attributes_for(:ad).merge(title: ''),
        user_id: user_id
      }
    }

    it 'does not create ad' do
      expect { service_called }.not_to change(Ad, :count)
    end

    it 'returns ad' do
      expect(service_called.ad).to be_a(Ad)
    end
  end
end
