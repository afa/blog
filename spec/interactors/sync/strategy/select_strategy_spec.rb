RSpec.describe Sync::Strategy::SelectStrategy do
  let(:interactor_call) { described_class.call(source:) }
  let(:value) { interactor_call.value!}

  context 'with blank strategy' do
    let(:source) { Sync::Source.new name: 'a', strategy: '' }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return zero strategy' do
      expect(value).to eq(Sync::Strategy::ZeroStrategy)
    end
  end

  context 'with nil strategy' do
    let(:source) { Sync::Source.new name: 'a', strategy: nil }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return zero strategy' do
      expect(value).to eq(Sync::Strategy::ZeroStrategy)
    end
  end

  context 'with running total' do
    let(:source) { Sync::Source.new name: 'a', strategy: 'running_total' }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return zero strategy' do
      expect(value).to eq(Sync::Strategy::RunningTotal)
    end
  end
end
