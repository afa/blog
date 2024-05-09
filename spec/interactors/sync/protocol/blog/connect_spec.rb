require 'spec_helper'
require 'dry/monads'
include Dry::Monads[:result]

RSpec.describe Sync::Protocol::Blog::Connect do
  let(:interactor_call) { described_class.call(source:, request_handler:) }
  let(:request_handler) { class_double(Sync::Protocol::Blog::Request) }

  context 'when valid' do
    include_context('with auth challenge')

    before do
      allow(request_handler).to(
        receive(:call)
        .with({ 'mode' => 'login' }.merge(ch_opts), source:)
        .and_return(Success({}))
      )
    end

    it 'return success' do
      expect(interactor_call).to be_success
    end
  end
end
