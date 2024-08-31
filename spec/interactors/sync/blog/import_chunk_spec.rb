require 'spec_helper'

RSpec.describe Sync::Blog::ImportChunk do
  let(:interactor_call) { described_class.call(source:, last_session:) }
  let(:source) {
    Sync::Source.create(name: 'a', kind: 'blog', api_url: '', login_options: {}, strategy: 'running_total')
  }

  context 'when diff from exist session' do
    let(:parent) { Sync::Session.create(source_id: source.id, timestamp: 10) }

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
