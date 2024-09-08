RSpec.describe Sync::Strategy::ZeroStrategy do
  let(:interactor_call) { described_class.call(data: [], session:) }
  let(:session) { Sync::Session.create(kind: 'blog') }

  it 'return success' do
    expect(interactor_call).to be_success
  end
end
