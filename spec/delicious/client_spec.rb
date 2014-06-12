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

  context 'requests' do
    let(:result) { :success }
    let(:success_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="done"/>' }
    let(:failure_boby) { '<?xml version="1.0" encoding="UTF-8"?><result code="error adding link"/>' }
    before do
      body = result == :failure ? failure_boby : success_body
      @request = stub_request(method, endpoint)
        .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
    end

    describe '#post' do
      let(:method)   { :post }
      let(:endpoint) { 'https://previous.delicious.com/v1/posts/add' }

      let(:attrs) do
        { url:         'http://example.com/cool-blog-post',
          description: 'Cool post, eh?',
          extended:    'Extended info',
          tags:        'tag1, tag2',
          dt:          '2014-05-04T22:01:00Z',
          replace:     'no',
          shared:      'no'
        }
      end
      let(:action) { client.post attrs }

      context 'valid attributes given' do
        it_behaves_like 'api action'

        context 'params' do
          it 'sends url=http://example.com/cool-blog-post' do
            action
            expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'url', 'http://example.com/cool-blog-post') }
          end

          it 'sends description=Cool post, eh?' do
            action
            expect(WebMock).to have_requested(:post, endpoint).with { |r| assert_param(r, 'description', 'Cool post, eh?') }
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

    describe '#delete' do
      let(:method)   { :post }
      let(:endpoint) { 'https://previous.delicious.com/v1/posts/delete' }
      let(:action)   { client.delete 'http://example.com' }
      let(:failure_boby) { '<?xml version="1.0" encoding="UTF-8"?><result code="The url or md5 could not be found."/>' }

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

    describe '#all' do
      let(:method)   { :get }
      let(:endpoint) { 'https://previous.delicious.com/v1/posts/all' }
      let(:action)   { client.all }
      let(:success_body) do
        <<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<posts tag="" total="748" user="slurmdrinker">
  <post description="Angular Classy" extended="" hash="ee7e657f5f5998fbc136e5910080bd85" href="http://davej.github.io/angular-classy/" private="no" shared="yes" tag="angularjs javascript controller angular angular.js library" time="2014-04-30T18:12:46Z"/>
  <post description="Postgresql Array and Hstore Column Reference - Application Development - HoneyCo" extended="" hash="598b527aa58ce750807b9b02308dde07" href="http://tastehoneyco.com/blog/postgresql-array-and-hstore-column-reference/?utm_source=rubyweekly&amp;utm_medium=email/" private="no" shared="yes" tag="postgresql rails ruby postgres hstore arrays" time="2014-04-20T18:00:21Z"/>
</posts>
EOT
      end

      it_behaves_like 'api action'

      it 'sends /v1/posts/all request' do
        action
        expect(WebMock).to have_requested(:get, endpoint)
      end

      describe 'result' do
        it 'has 2 items' do
          expect(action.count).to eq 2
        end

        describe 'first' do
          it 'is an instance of Delicious::Post' do
            expect(action.first).to be_an_instance_of Delicious::Post
          end

          it 'has attributes set' do
            post = action.first
            expect(post.description).to eq 'Angular Classy'
          end

          it 'is persisted' do
            post = action.first
            expect(post).to be_persisted
          end

          it 'can be deleted' do
            post = action.first
            expect(client).to receive(:delete).with(url: post.url)
            post.delete
          end
        end
      end
    end
  end
end
