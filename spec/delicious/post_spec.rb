describe Delicious::Post do
  it { should validate_presence_of :url }
  it { should validate_presence_of :description }

  it 'defaults shared to false' do
    expect(described_class.new.shared).to eq false
  end

  describe '#delete' do
    context 'persisted' do
      before do
        stub_request(:post, 'https://previous.delicious.com/v1/posts/add')
          .to_return body: '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>', 
                     headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
      end

      it 'invokes delete with the URL on associated client' do
        client = Delicious::Client.new { |c| c.access_token = 'my-access-token' }
        post = client.bookmarks.create url: 'http://example.com', description: 'Cool site'
        expect(client.bookmarks).to receive(:delete).with url: 'http://example.com'
        post.delete
      end
    end

    context 'not persisted' do
      it 'throws an error' do
        post = described_class.new url: 'http://example.com', description: 'Cool site'
        expect { post.delete }.to raise_error('Bookmark was not saved yet')
      end
    end
  end
end
