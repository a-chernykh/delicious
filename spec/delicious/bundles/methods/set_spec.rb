require 'spec_helper'

describe Delicious::Bundles::Methods::Set do
  let(:client) do
    Delicious::Client.new do |config|
      config.access_token = 'my-access-token'
    end
  end

  describe '#set' do
    let(:result) { :success }

    let(:bundle) { 'hardware' }
    let(:tags)   { %w(tag1 tag2) }

    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/set' }
    let(:action)   { client.bundles.set bundle, tags }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result>ok</result>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result>tagbundle name is required</result>' }

    before do
      body = result == :failure ? failure_body : success_body
      @request = stub_request(method, endpoint)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    context 'valid attrs given' do
      it_behaves_like 'api action'

      it 'sends post to /v1/tags/bundles/set' do
        action
        expect(WebMock).to have_requested(:post, endpoint).with do |r| 
          assert_param(r, 'bundle', 'hardware') && assert_param(r, 'tags', 'tag1,tag2')
        end
      end

      context 'ok from server' do
        it 'returns an instance of Delicious::Bundle' do
          expect(action).to be_an_instance_of(Delicious::Bundle)
        end

        it 'has name' do
          expect(action.name).to eq 'hardware'
        end

        it 'has tags' do
          expect(action.tags).to eq %w(tag1 tag2)
        end
      end

      context 'error on server' do
        let(:result) { :failure }

        it 'throws an error' do
          expect { action }.to raise_error Delicious::Error
        end
      end
    end

    context 'bundle name omitted' do
      let(:bundle) { nil }

      it 'throws an error' do
        expect { action }.to raise_error(Delicious::Error, "Bundle name can't be blank")
      end
    end

    context 'tags are empty' do
      let(:tags) { nil }

      it 'throws an error' do
        expect { action }.to raise_error(Delicious::Error, "Please specify at least 1 tag")
      end        
    end
  end
end