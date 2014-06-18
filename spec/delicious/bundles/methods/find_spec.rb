require 'spec_helper'

describe Delicious::Bundles::Methods::Find do
  describe '#find' do
    let(:method)   { :get }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/all?bundle=hardware' }

    let(:success_body) do
      <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<bundles>
<bundle name="hardware" tags="cpu hardware wifi"/>
</bundles>
EOT
    end
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?>' }

    let(:action)   { client.bundles.find 'hardware' }

    include_context 'api action context'
    it_behaves_like 'api action'

    it 'sends /v1/tags/bundles/all request' do
      action
      expect(WebMock).to have_requested(:get, endpoint)
    end

    context 'found' do
      let(:result) { :success }

      it 'returns bundle instance' do
        expect(action).to be_an_instance_of Delicious::Bundle
      end

      it 'sets name' do
        expect(action.name).to eq 'hardware'
      end

      it 'sets tags' do
        expect(action.tags).to eq %w(cpu hardware wifi)
      end

      it 'can be deleted' do
        bundle = action
        expect(client.bundles).to receive(:delete).with(bundle: bundle.name)
        bundle.delete
      end
    end

    context 'not found' do
      let(:result) { :failure }

      it 'is nil' do
        expect(action).to be_nil
      end
    end
  end
end
