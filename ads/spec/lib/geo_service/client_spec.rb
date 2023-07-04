# frozen_string_literal: true

RSpec.describe GeoService::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) {
    { 'Content-Type' => 'application/json' }
  }
  let(:body) {
    { 'data' => { 'lat' => 45.05, 'lon' => 90.05 } }
  }

  before do
    stubs.get('') { [status, headers, body.to_json] }
  end

  it { expect(subject.coordinates('city')).to eq({ 'lat' => 45.05, 'lon' => 90.05 }) }
end
