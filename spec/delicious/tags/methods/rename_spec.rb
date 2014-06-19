# encoding: utf-8

describe Delicious::Tags::Methods::Rename do
  describe '#rename' do
    let(:endpoint) { 'https://previous.delicious.com/v1/tags/rename' }
    let(:method)   { :post }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }

    let(:action) { client.tags.rename 'old', 'new' }

    include_context 'api action context'
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
