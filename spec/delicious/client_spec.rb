require 'spec_helper'

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

  context 'actions' do
    let(:result)       { :success }
    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="error adding link"/>' }
    before do
      body = result == :failure ? failure_body : success_body
      @request = stub_request(method, endpoint)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    describe '#bookmarks' do
      describe '#delete' do
        let(:method)   { :post }
        let(:endpoint) { 'https://previous.delicious.com/v1/posts/delete' }
        let(:action)   { client.bookmarks.delete 'http://example.com' }
        let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="The url or md5 could not be found."/>' }

        it_behaves_like 'api action'

        it 'sends url=http://example.com' do
          action
          expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'url', 'http://example.com') }
        end

        context 'existing URL' do
          it 'returns true' do
            expect(action).to eq true
          end
        end

        context 'non-existing URL' do
          let(:result) { :failure }

          it 'return false' do
            expect(action).to eq false
          end
        end
      end
    end

    describe '#bundles' do
      describe '#find' do
        let(:method)   { :get }
        let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/all?bundle=hardware' }
        let(:action)   { client.bundles.find 'hardware' }
        let(:success_body) do
          <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<bundles>
  <bundle name="hardware" tags="cpu hardware wifi"/>
</bundles>
EOT
        end
        let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?>' }

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

      describe '#all' do
        let(:method)   { :get }
        let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/all' }
        let(:action)   { client.bundles.all }
        let(:success_body) do
          <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<bundles>
  <bundle name="hardware" tags="cpu hardware wifi"/>
  <bundle name="software" tags="editor graphics programming"/>
</bundles>
EOT
        end

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

    describe '#delete' do
      let(:method)   { :post }
      let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/delete' }
      let(:action)   { client.bundles.delete 'hardware' }
      let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="The url or md5 could not be found."/>' }

      it_behaves_like 'api action'

      it 'sends post to /v1/tags/bundles/delete' do
        action
        expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'bundle', 'hardware') }
      end

      context 'existing URL' do
        it 'returns true' do
          expect(action).to eq true
        end
      end
    end
  end

  describe '#tags' do
    it 'is an instance of Delicious::Tags::Api' do
      expect(client.tags).to be_an_instance_of Delicious::Tags::Api
    end
  end
end
