# frozen_string_literal: true

RSpec.describe Users::CreateService do
  let(:service_called) { described_class.call(*params) }
  let(:params) { %w[Name email pass] }

  context 'when success' do
    it 'creates a new user' do
      expect { service_called }.to change(User, :count).by(1)
    end

    it 'returns user' do
      expect(service_called.user).to be_a(User)
    end
  end

  context 'when failure' do
    let(:params) { ['Name', '', 'pass'] }

    it 'does not create user' do
      expect { service_called }.not_to change(User, :count)
    end

    it 'returns user' do
      expect(service_called.user).to be_a(User)
    end
  end
end
