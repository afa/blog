require 'spec_helper'

RSpec.describe(Sync::Blog::SyncronizedChunkRepository) do
  describe('#all') do
    let(:repository_call) { described_class.new(cache_handler: cache, source:).all }
    let(:cache) { instance_double(Sync::Blog::SyncronizedChunkInstanceCache) }
    let(:source) { Sync::Source.new(api_url: 'http://localhost/', login_options: {}) }
    let(:value) { repository_call.value! }
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
    let(:result) {
      [
        {
          'anum' => '228', 'event' => 'testevent', 'eventtime' => DateTime.new(2006, 9, 10, 17, 10, 0),
          'itemid' => '108', 'subject' => '[mobile]', 'url' => 'https://afa-at-work.livejournal.com/27876.html',
          'props' => [{ 'name' => 'personifi_tags', 'value' => 'nterms:yes' }]
        }
      ]
    }

    before do
      allow(cache).to receive(:cache?).and_return(false)
      allow(cache).to receive(:refresh_cache).and_return(Success(result))
      allow(Sync::Protocol::Blog::Getevents).to receive(:call).and_return(Success(answer))
    end

    it 'returns success' do
      expect(repository_call).to be_success
    end

    it 'returns valid values' do
      expect(value).to eq(result)
    end
  end
end
