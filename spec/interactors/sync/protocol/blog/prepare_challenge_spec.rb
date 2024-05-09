require 'spec_helper'
require 'dry/monads'
include Dry::Monads[:result]
RSpec.describe Sync::Protocol::Blog::PrepareChallenge do
  let(:interactor_call) { described_class.call(source:, request_handler:) }

  context 'when valid' do
    include_context('with auth challenge')

    let(:request_handler) { class_double(Sync::Protocol::Blog::Request) }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'returns challenge hash' do
      expect(interactor_call.value!).to eq(ch_opts)
    end
  end
end
