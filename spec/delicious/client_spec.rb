describe Delicious::Client do
  let(:client) do
    described_class.new do |config|
      config.access_token = 'my-access-token'
    end
  end

  describe 'configuration' do
    it 'sets access_token to my-access-token' do
      expect(client.access_token).to eq 'my-access-token'
    end

    it 'sets access_token to another-access-token' do
      another_client = described_class.new { |config| config.access_token = 'another-access-token' }
      expect(another_client.access_token).to eq 'another-access-token'
    end
  end

  describe '#bookmarks' do
    it 'is an instance of Delicious::Bookmarks::Api' do
      expect(client.bookmarks).to be_an_instance_of Delicious::Bookmarks::Api
    end
  end

  describe '#bundles' do
    it 'is an instance of Delicious::Bundles::Api' do
      expect(client.bundles).to be_an_instance_of Delicious::Bundles::Api
    end
  end

  describe '#tags' do
    it 'is an instance of Delicious::Tags::Api' do
      expect(client.tags).to be_an_instance_of Delicious::Tags::Api
    end
  end

  describe '#connection' do
    it 'is an instance of Faraday::Connection' do
      expect(client.connection).to be_an_instance_of Faraday::Connection
    end

    it 'has https://previous.delicious.com URL' do
      expect(client.connection.url_prefix.to_s).to eq 'https://previous.delicious.com/'
    end
  end
end
