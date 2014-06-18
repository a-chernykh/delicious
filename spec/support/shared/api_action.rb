RSpec.shared_context 'api action context' do
  let(:client) do
    Delicious::Client.new do |config|
      config.access_token = 'my-access-token'
    end
  end

  let(:result) { :success }
  before do
    body = result == :failure ? failure_body : success_body
    @request = stub_request(method, endpoint)
      .to_return body: body, headers: {'Content-Type' => 'text/xml; charset=UTF-8'}
  end
end

RSpec.shared_examples 'api action' do
  it 'adds "Authorization: Bearer my-access-token" header' do
    action
    expect(WebMock).to have_requested(method, endpoint)
      .with(headers: { 'Authorization' => 'Bearer my-access-token' })
  end

  it 'adds "User-Agent: delicious-ruby X.Y.Z" header' do
    action
    expect(WebMock).to have_requested(method, endpoint)
      .with(headers: { 'User-Agent' => "delicious-ruby #{Delicious.version}" })
  end
end
