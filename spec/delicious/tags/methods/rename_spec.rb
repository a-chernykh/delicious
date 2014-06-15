require 'spec_helper'

describe Delicious::Tags::Methods::Rename do
  let(:client) do
    Delicious::Client.new do |config|
      config.access_token = 'my-access-token'
    end
  end

  describe '#rename' do
    let(:result) { :success }

    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/rename' }
    let(:action)   { client.tags.rename 'old', 'new' }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }

    before do
      body = result == :failure ? failure_body : success_body
      @request = stub_request(method, endpoint)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    it_behaves_like 'api action'

    it 'sends request' do
      action
      expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'old', 'old') && assert_param(r, 'new', 'new') }
    end

    context 'success' do
      it 'return true' do
        expect(action).to eq true
      end
    end

    context 'failure' do
      let(:result) { :failure }

      it 'return true' do
        expect(action).to eq true
      end
    end
  end
end
