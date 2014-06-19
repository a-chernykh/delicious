# encoding: utf-8

describe Delicious::Bookmarks::Methods::Create do
  describe '#create' do
    let(:method)   { :post }
    let(:endpoint) { 'https://previous.delicious.com/v1/posts/add' }

    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="error adding link"/>' }

    let(:tags) { 'tag1, tag2' }
    let(:dt)   { '2014-05-04T22:01:00Z' }
    let(:attrs) do
      { url:         'http://example.com/cool-blog-post',
        description: 'Cool post, eh?',
        extended:    'Extended info',
        tags:        tags,
        dt:          dt,
        replace:     'no',
        shared:      'no'
      }
    end

    let(:action) { client.bookmarks.create attrs }

    include_context 'api action context'
    it_behaves_like 'api action'

    context 'valid attributes given' do
      context 'params' do
        it 'sends url=http://example.com/cool-blog-post' do
          action
          expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'url', 'http://example.com/cool-blog-post') }
        end

        it 'sends description=Cool post, eh?' do
          action
          expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'description', 'Cool post, eh?') }
        end

        describe 'tags' do
          context 'comma-separated string' do
            let(:tags) { 'tag1,tag2' }

            it 'sends tags=tag1, tag2' do
              action
              expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'tags', 'tag1,tag2') }
            end
          end

          context 'array of tags' do
            let(:tags) { %w(tag1 tag2) }

            it 'sends tags=tag1, tag2' do
              action
              expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'tags', 'tag1,tag2') }
            end
          end
        end
      end

      describe 'result' do
        subject { action }

        context 'success' do
          let(:result) { :success }

          it { should be_an_instance_of Delicious::Post }
          it 'has url' do
            expect(subject.url).to eq 'http://example.com/cool-blog-post'
          end
          it 'returns not persisted Post object' do
            expect(subject).to be_persisted
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

    context 'invalid attributes given' do
      let(:attrs) do
        { description: 'Cool site' }
      end

      it 'does not sends request' do
        action
        expect(WebMock).not_to have_requested(:post, endpoint)
      end

      it 'returns invalid Post object' do
        p = action
        expect(p).not_to be_valid
      end

      it 'returns not persisted Post object' do
        p = action
        expect(p).not_to be_persisted
      end
    end
  end
end
