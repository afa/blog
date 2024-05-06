require 'spec_helper'
require 'dry/monads'
include Dry::Monads[:result]
RSpec.describe Sync::Blog::Getevents do
  let(:interactor_call) { described_class.call(source:, request_handler:) }

  context 'when valid' do
    include_context('with auth challenge')
    let(:request_handler) { class_double(Sync::Blog::Request) }

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
