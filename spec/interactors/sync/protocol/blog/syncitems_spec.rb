require 'spec_helper'
require 'dry/monads'
include Dry::Monads[:result]
RSpec.describe Sync::Protocol::Blog::Syncitems do
  let(:interactor_call) { described_class.call(source:, request_handler:) }
  let(:request_handler) { class_double(Sync::Protocol::Blog::Request) }
  let(:value) { interactor_call.value! }

  context 'when valid' do
    include_context('with auth challenge')

    let(:resp) {
      {
        'success' => 'OK', 'sync_1_action' => 'create', 'sync_1_item' => 'L-72', 'sync_1_time' => '2006-06-19 09:33:51',
        'sync_2_action' => 'update', 'sync_2_item' => 'L-59', 'sync_2_time' => '2006-06-19 09:41:08.000000',
        'sync_count' => '2', 'sync_total' => '1385'
      }
    }
    let(:answer) {
      {
        'sync_count' => '2',
        'sync_items' => [
          { 'action' => 'create', 'item' => 'L-72', 'time' => '2006-06-19 09:33:51' },
          { 'action' => 'update', 'item' => 'L-59', 'time' => '2006-06-19 09:41:08.000000' }
        ],
        'sync_total' => '1385',
        'success' => 'OK'
      }
    }

    before do
      allow(request_handler).to(
        receive(:call)
        .with({ 'mode' => 'syncitems', 'ver' => '1' }.merge(ch_opts), source:)
        .and_return(Success(resp))
      )
    end

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'returns valid object' do
      expect(value).to eq(answer)
    end
  end
end
