describe Delicious::Bookmarks::Methods::All do
  describe '#all' do
    let(:method)   { :get }
    let(:endpoint) { %r{https:\/\/previous\.delicious\.com\/v1\/posts\/all\?(.+)} }

    let(:success_body) do
      <<-EOT
  <?xml version="1.0" encoding="UTF-8"?>
  <posts tag="" total="748" user="slurmdrinker">
    <post description="Angular Classy" extended="" hash="ee7e657f5f5998fbc136e5910080bd85" href="http://davej.github.io/angular-classy/" private="no" shared="yes" tag="angularjs,javascript,controller,angular,angular.js,library" time="2014-04-30T18:12:46Z"/>
    <post description="Postgresql Array and Hstore Column Reference - Application Development - HoneyCo" extended="" hash="598b527aa58ce750807b9b02308dde07" href="http://tastehoneyco.com/blog/postgresql-array-and-hstore-column-reference/?utm_source=rubyweekly&amp;utm_medium=email/" private="no" shared="yes" tag="postgresql,rails,ruby,postgres,hstore,arrays" time="2014-04-20T18:00:21Z"/>
  </posts>
  EOT
    end
    let(:failure_body) { '<?xml version="1.0" encoding="UTF-8"?><result code="no bookmarks"/>' }

    let(:action) { client.bookmarks.all.to_a }

    include_context 'api action context'
    it_behaves_like 'api action'

    it 'sends /v1/posts/all request' do
      action
      expect(WebMock).to have_requested(:get, endpoint)
    end

    describe 'no bookmarks' do
      let(:result) { :failure }

      it 'returns empty array' do
        expect(action).to eq []
      end
    end

    describe 'limit / offset' do
      it 'allows to limit count of results' do
        client.bookmarks.all.limit(10).to_a
        expect(WebMock).to have_requested(:get, endpoint).with(query: hash_including('results' => '10'))
      end

      it 'allows to start results with given offset' do
        client.bookmarks.all.offset(10).to_a
        expect(WebMock).to have_requested(:get, endpoint).with(query: hash_including('start' => '10'))
      end

      it 'allows to specify limit and offset at the same time' do
        client.bookmarks.all.offset(10).limit(15).to_a
        expect(WebMock).to have_requested(:get, endpoint).with(query: hash_including('start' => '10', 'results' => '15'))
      end
    end

    describe 'filtering' do
      it 'by tag' do
        client.bookmarks.all.tag('angular').to_a
        expect(WebMock).to have_requested(:get, endpoint).with(query: hash_including('tag' => 'angular'))
      end

      context 'by date' do
        it 'accepts Time instances' do
          from = Time.parse '2013-11-12T10:23:00Z'
          to = Time.parse '2013-11-13T12:10:00Z'
          client.bookmarks.all.from(from).to(to).to_a
          expect(WebMock).to have_requested(:get, endpoint)
            .with(query: hash_including('fromdt' => '2013-11-12T10:23:00Z',
                                        'todt'   => '2013-11-13T12:10:00Z'))
        end

        it 'accepts strings' do
          from = '2013/11/12 10:23:00'
          to = '2013/11/13 12:10:00'
          client.bookmarks.all.from(from).to(to).to_a
          expect(WebMock).to have_requested(:get, endpoint)
            .with(query: hash_including('fromdt' => '2013-11-12T10:23:00Z',
                                        'todt'   => '2013-11-13T12:10:00Z'))
        end
      end
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
          expect(post.tags).to eq %w(angularjs javascript controller angular angular.js library)
          expect(post.shared).to eq true
          expect(post.dt).to eq '2014-04-30T18:12:46Z'
        end

        it 'is persisted' do
          post = action.first
          expect(post).to be_persisted
        end

        it 'can be deleted' do
          post = action.first
          expect(client.bookmarks).to receive(:delete).with(url: post.url)
          post.delete
        end
      end
    end
  end
end
