require 'spec_helper'

describe Delicious::Bundles::Methods::Delete do
  describe '#delete' do
    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/bundles/delete' }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="The url or md5 could not be found."/>' }

    let(:action)   { client.bundles.delete 'hardware' }

    include_context 'api action context'
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
