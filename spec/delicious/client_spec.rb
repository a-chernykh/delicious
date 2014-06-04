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
  end

  describe '#post' do
    ENDPOINT = 'https://previous.delicious.com/v1/posts/add'

    let(:result) { :success }

    before do
      body = if result == :failure
               '<?xml version="1.0" encoding="UTF-8"?><result code="error adding link"/>'
             else
               '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>'
             end
      request = stub_request(:post, ENDPOINT)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    let(:post) do
      client.post url: 'http://example.com/cool-blog-post', 
                  description: 'Cool post, eh?',
                  extended: 'Extended info',
                  tags: 'tag1, tag2',
                  dt: '2014-05-04T22:01:00Z',
                  replace: 'no',
                  shared: 'no'
    end

    it 'adds "Authorization: Bearer my-access-token" header' do
      post
      expect(WebMock).to have_requested(:post, ENDPOINT)
        .with(headers: { 'Authorization' => 'Bearer my-access-token' })
    end

    context 'params' do
      it 'sends url=http://example.com/cool-blog-post' do
        post
        expect(WebMock).to have_requested(:post, ENDPOINT).with { |r| assert_param(r, 'url', 'http://example.com/cool-blog-post') }
      end

      it 'sends description=Cool post, eh?' do
        post
        expect(WebMock).to have_requested(:post, ENDPOINT).with { |r| assert_param(r, 'description', 'Cool post, eh?') }
      end
    end

    describe 'result' do
      subject { post }

      context 'success' do
        let(:result) { :success }

        it { should be_an_instance_of Delicious::Post }
        it 'has url' do
          expect(subject.url).to eq 'http://example.com/cool-blog-post'
        end
      end

      context 'failure' do
        let(:result) { :failure }

        it 'throws an error' do
          expect { subject }.to raise_error
        end
      end
    end
  end
end
