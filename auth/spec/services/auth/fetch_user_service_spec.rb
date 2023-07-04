# frozen_string_literal: true

RSpec.describe Auth::FetchUserService do
  let(:service_called) { described_class.call(uuid) }

  context 'with valid parameters' do
    let(:session) { create(:user_session) }
    let(:uuid) { session.uuid }

    it 'assigns user' do
      expect(service_called.user).to eq(session.user)
    end
  end

  context 'with invalid parameters' do
    let(:uuid) { 'invalid' }

    it 'does not assign user' do
      expect(service_called.user).to be_nil
    end

    it 'adds an error' do
      result = service_called

      expect(result).to be_failure
      expect(result.errors).to include('No permission to access the resource')
    end
  end
end
