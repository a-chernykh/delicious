# encoding: utf-8

describe Delicious::Bundle do
  it { should validate_presence_of :name }
  it { should validate_presence_of :tags }

  describe '#delete' do
    context 'persisted' do
      it 'invokes delete with the bundle name on associated client' do
        client = ::Delicious::Client.new { |c| c.access_token = 'my-access-token' }
        bundle = described_class.build_persisted client, name: 'mybundle', tags: %w(tag1 tag2)
        expect(client.bundles).to receive(:delete).with bundle: 'mybundle'
        bundle.delete
      end
    end

    context 'not persisted' do
      it 'throws an error' do
        bundle = described_class.new name: 'mybundle', tags: %w(tag1 tag2)
        expect { bundle.delete }.to raise_error('Bundle was not saved yet')
      end
    end
  end

  describe '#save' do
    context 'persisted' do
      it 'invokes set with bundle attrs on associated client' do
        client = ::Delicious::Client.new { |c| c.access_token = 'my-access-token' }
        bundle = described_class.build_persisted client, name: 'mybundle', tags: %w(tag1 tag2)
        expect(client.bundles).to receive(:set).with('mybundle', %w(tag1 tag2))
        expect(bundle.save).to eq true
      end
    end

    context 'not persisted' do
      it 'throws an error' do
        bundle = described_class.new name: 'mybundle', tags: %w(tag1 tag2)
        expect { bundle.save }.to raise_error('Bundle was not saved yet')
      end
    end
  end
end
