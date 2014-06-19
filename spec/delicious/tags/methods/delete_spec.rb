# encoding: utf-8

describe Delicious::Tags::Methods::Delete do
  describe '#delete' do
    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/delete' }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }

    let(:action) { client.tags.delete 'ruby' }

    include_context 'api action context'
    it_behaves_like 'api action'

    it 'sends request' do
      action
      expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'tag', 'ruby') }
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
