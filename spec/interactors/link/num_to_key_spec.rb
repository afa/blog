RSpec.describe Link::NumToKey do
  let(:interactor_call) { described_class.call(key) }
  let(:value) { interactor_call.value! }

  context 'when nonnumber' do
    let(:key) { '' }

    it 'return fail' do
      expect(interactor_call).to be_failure
    end
  end

  context 'when 1' do
    let(:key) { 1 }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return value' do
      expect(value).to eq('B')
    end
  end

  context 'when 50' do
    let(:key) { 50 }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return value' do
      expect(value).to eq('A9')
    end
  end
end
