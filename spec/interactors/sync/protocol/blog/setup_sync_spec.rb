require 'spec_helper'

RSpec.describe(Sync::Protocol::Blog::SetupSync) do
  let(:interactor_call) { described_class.call(source:) }
  let(:source) { Sync::Source.create(src_params) }
  let(:src_params) { { kind: 'blog' } }

  context 'with success path' do
    context 'with prev session' do
      let!(:parent) { Sync::Session.create(kind: 'blog', timestamp: 10, source_id: source.id) }

      it 'return success' do
        expect(interactor_call).to be_success
      end
    end

    context 'when first import' do
      it 'rertun success' do
        expect(interactor_call).to be_success
      end
    end
  end
end
