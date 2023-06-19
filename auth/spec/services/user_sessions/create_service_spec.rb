# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  let(:service_called) { described_class.call(*params) }

  let(:email) { 'bob@example.com' }
  let(:password) { 'givemeatoken' }
  let(:params) { [email, password] }

  context 'with valid parameters' do
    let!(:user) { create(:user, email: email, password: password) }

    it 'creates a new session' do
      expect { service_called }.to change { user.sessions(reload: true).count }.by(1)
    end

    it 'assigns session' do
      expect(service_called.session).to be_a(UserSession)
    end
  end

  context 'with invalid parameters' do
    context 'when user is missing' do
      let!(:user) { create(:user, email: 'bill@example.com', password: password) }

      it 'does not create session' do
        expect { service_called }.not_to change(UserSession, :count)
      end

      it 'adds an error' do
        result = service_called

        expect(result).to be_failure
        expect(result.errors).to include('Session can be created')
      end
    end

    context 'when password is ivalid' do
      let(:params) { [email, 'invalid'] }
      let!(:user) { create(:user, email: email, password: password) }

      it 'does not create session' do
        expect { service_called }.not_to change(UserSession, :count)
      end

      it 'adds an error' do
        result = service_called

        expect(result).to be_failure
        expect(result.errors).to include('Session can be created')
      end
    end
  end
end
