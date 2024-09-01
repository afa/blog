require 'spec_helper'
require 'dry/monads/all'

RSpec.describe Sync::Blog::ImportChunk do
  include Dry::Monads
  let(:interactor_call) { described_class.call(source:, cache:) }
  let(:source) {
    Sync::Source.create(name: 'a', kind: 'blog', api_url: '', login_options: {}, strategy: nil)
  }
  let(:cache) { Sync::Blog::SyncronizedChunkInstanceCache.new }
  let(:data) {
    [
      {"anum"=>"187", "event"=>"ev1", "eventtime"=>DateTime.new(2004, 07, 22, 17, 43, 00), "itemid"=>"1", "subject"=>"s1", "url"=>"https://afa-at-work.livejournal.com/443.html", "props"=>[{"name"=>"personifi_tags", "value"=>"nterms:yes"}]},
      {"anum"=>"121", "event"=>"ev2", "eventtime"=>DateTime.new(2004, 7, 24, 18, 38, 0), "itemid"=>"2", "subject"=>"s2", "url"=>"https://afa-at-work.livejournal.com/633.html", "props"=>[{"name"=>"personifi_tags", "value"=>"nterms:yes"}]}
    ]
  }

  before do
    allow(cache).to receive(:cache?).and_return(true)
    allow(cache).to receive(:cached_data).and_return(Success(data))
  end

  context 'when diff from exist session' do
    before do
      Sync::Session.create(source_id: source.id, timestamp: 10)
    end

    it 'return success' do
      expect(interactor_call).to be_success
    end
  end

  context 'when initial import' do
    it 'return success' do
      expect(interactor_call).to be_success
    end
  end
end
