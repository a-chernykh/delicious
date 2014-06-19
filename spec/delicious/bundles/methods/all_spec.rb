# encoding: utf-8

describe Delicious::Bundles::Methods::All do
  describe '#all' do
    let(:method)   { :get }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/all' }

    let(:success_body) do
      <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<bundles>
<bundle name="hardware" tags="cpu hardware wifi"/>
<bundle name="software" tags="editor graphics programming"/>
</bundles>
EOT
    end

    let(:action) { client.bundles.all }

    include_context 'api action context'
    it_behaves_like 'api action'

    it 'sends /v1/tags/bundles/all request' do
      action
      expect(WebMock).to have_requested(:get, endpoint)
    end

    it 'returns array of 2 bundles' do
      expect(action.count).to eq 2
    end

    describe 'first' do
      it 'has name' do
        expect(action[0].name).to eq 'hardware'
      end

      it 'has tags' do
        expect(action[0].tags).to eq %w(cpu hardware wifi)
      end

      it 'can be deleted' do
        bundle = action[0]
        expect(client.bundles).to receive(:delete).with(bundle: 'hardware')
        bundle.delete
      end
    end

    describe 'second' do
      it 'has name' do
        expect(action[1].name).to eq 'software'
      end
    end
  end
end
