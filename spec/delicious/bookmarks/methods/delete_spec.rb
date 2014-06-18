require 'spec_helper'

describe Delicious::Bookmarks::Methods::Delete do
  describe '#delete' do
    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/posts/delete' }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="The url or md5 could not be found."/>' }

    let(:action)   { client.bookmarks.delete 'http://example.com' }

    include_context 'api action context'
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
