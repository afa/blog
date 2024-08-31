require 'spec_helper'

RSpec.describe Sync::Blog::ImportChunk do
  let(:interactor_call) { described_class.call(source:, last_session:) }
  let(:source) { Sync::Source.create(name: 'a', kind: 'blog', api_url: '', login_options: {}, strategy: 'running_total') }
  let(:last_session) {}

  context 'when initial import' do
    it 'return success' do
      pp interactor_call.trace
      expect(interactor_call).to be_success
    end
  end
end
