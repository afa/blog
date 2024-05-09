require 'spec_helper'
require 'dry/monads'
include Dry::Monads[:result]
RSpec.describe Sync::Protocol::Blog::Getevents do
  let(:interactor_call) { described_class.call(source:, request_handler:) }
  let(:request_handler) { class_double(Sync::Protocol::Blog::Request) }
  let(:value) { interactor_call.value! }

  context 'when valid' do
    include_context('with auth challenge')
    let(:resp) {
      {
        'events_1_anum' => '228', 'events_1_event' => 'testevent', 'events_1_eventtime' => '2006-09-10 17:10:00',
        'events_1_itemid' => '108', 'events_1_subject' => '[mobile]',
        'events_1_url' => 'https://afa-at-work.livejournal.com/27876.html',
        'events_count' => '1',
        'prop_1_itemid' => '108', 'prop_1_name' => 'personifi_tags', 'prop_1_value' => 'nterms:yes',
        'prop_count' => '1',
        'success' => 'OK'
      }
    }
    let(:answer) {
      {
        'events' => [
          {
            'anum' => '228', 'event' => 'testevent', 'eventtime' => DateTime.new(2006, 9, 10, 17, 10, 0),
            'itemid' => '108', 'subject' => '[mobile]', 'url' => 'https://afa-at-work.livejournal.com/27876.html'
          }
        ],
        'events_count' => '1',
        'prop_count' => '1',
        'props' => [{ 'itemid' => '108', 'name' => 'personifi_tags', 'value' => 'nterms:yes' }],
        'success' => 'OK'
      }
    }

    before do
      allow(request_handler).to(
        receive(:call)
        .with({ 'mode' => 'getevents', 'selecttype' => 'syncitems', 'ver' => '1' }.merge(ch_opts), source:)
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
