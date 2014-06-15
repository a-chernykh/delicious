require 'spec_helper'

describe Delicious::Tags::Methods::All do
  let(:client) do
    Delicious::Client.new do |config|
      config.access_token = 'my-access-token'
    end
  end

  describe '#all' do
    let(:result) { :success }

    let(:method)   { :get }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/get' }
    let(:action)   { client.tags.all }

    let(:success_body) do
      <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<tags>
  <tag count="78" tag="ruby"/>
  <tag count="70" tag="rails"/>
  <tag count="58" tag="css"/>
</tags>
EOT
    end
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="access denied"/>' }

    before do
      body = result == :failure ? failure_body : success_body
      @request = stub_request(method, endpoint)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    it_behaves_like 'api action'

    context 'success' do
      it 'returns 3 tags' do
        expect(action.count).to eq 3
      end

      describe 'first tag' do
        subject { action[0] }

        it { should be_an_instance_of Delicious::Tag }

        it 'has name' do
          expect(subject.name).to eq 'ruby'
        end

        it 'has count' do
          expect(subject.count).to eq 78
        end

        it 'is possible to delete' do
          expect(client.tags).to receive(:delete).with 'ruby'
          subject.delete
        end
      end
    end

    context 'failure' do
      let(:result) { :failure }

      it 'throws an error' do
        expect { action }.to raise_error Delicious::Error
      end
    end
  end
end
