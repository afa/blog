RSpec.describe Sync::Strategy::RunningTotal do
  let(:interactor_call) { described_class.call(data:, session:) }
  let(:data) {
    {
      'posts' => [
        {
          'anum' => '187', 'event' => 'ev1', 'eventtime' => DateTime.new(2004, 7, 22, 17, 43, 0), 'itemid' => '1',
          'subject' => 's1', 'url' => 'https://afa-at-work.livejournal.com/443.html',
          'props' => [{ 'name' => 'personifi_tags', 'value' => 'nterms:yes' }]
        },
        {
          'anum' => '121', 'event' => 'ev2', 'eventtime' => DateTime.new(2004, 7, 24, 18, 38, 0), 'itemid' => '2',
          'subject' => 's2', 'url' => 'https://afa-at-work.livejournal.com/633.html',
          'props' => [{ 'name' => 'personifi_tags', 'value' => 'nterms:yes' }]
        }
      ]
    }
  }
  let(:session) { Sync::Session.create kind: 'blog', source_id: source.id }
  let(:source) { Sync::Source.create kind: 'blog', name: 'a' }
  let!(:structure) { Sync::Structure.create(source_id: source.id, structure_rules: rules) }
  let(:rules) {
    {
      posts: {
        attributes: {
          anum: nil, event: nil, eventtime: nil, itemid: nil, subject: nil, url: nil
        },
        objects: {}, associations: %i[props]
      },
      props: {attributes: {name: nil, value: nil}, objects: {}, associations: []}
    }
  }

  context 'with success path' do
    it 'return success' do
      expect(interactor_call).to be_success
    end
  end
end
