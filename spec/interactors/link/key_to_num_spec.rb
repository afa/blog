RSpec.describe Link::KeyToNum do
  let(:interactor_call) { described_class.call(key) }
  let(:value) { interactor_call.value! }

  context 'when blank' do
    let(:key) { nil }

    it 'return fail' do
      expect(interactor_call).to be_failure
    end
  end

  context 'when A' do
    let(:key) { 'A' }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return value' do
      expect(value).to eq(0)
    end
  end

  context 'when A9' do
    let(:key) { 'A9' }

    it 'return success' do
      expect(interactor_call).to be_success
    end

    it 'return value' do
      expect(value).to eq(50)
    end
  end

  context 'when run forward-backward' do
    it 'returns same value' do
      100.times do |val|
        expect(described_class.call(Link::NumToKey.call(val).value!).value!).to eq(val)
      end
    end
  end
end
