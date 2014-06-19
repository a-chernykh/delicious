describe Delicious::Tag do
  describe '#delete' do
    context 'persisted' do
      it 'invokes delete with the tag name on associated client' do
        client = ::Delicious::Client.new { |c| c.access_token = 'my-access-token' }
        tag = described_class.build_persisted client, name: 'tag1', count: 100
        expect(client.tags).to receive(:delete).with 'tag1'
        tag.delete
      end
    end

    context 'not persisted' do
      it 'throws an error' do
        tag = described_class.new name: 'tag1', count: 100
        expect { tag.delete }.to raise_error('Tag was not saved yet')
      end
    end
  end
end
