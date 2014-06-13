RSpec.shared_examples 'api action' do
  it 'adds "Authorization: Bearer my-access-token" header' do
    action
    expect(WebMock).to have_requested(method, endpoint)
      .with(headers: { 'Authorization' => 'Bearer my-access-token' })
  end

  it 'adds "User-Agent: delicious-ruby 0.0.1" header' do
    action
    expect(WebMock).to have_requested(method, endpoint)
      .with(headers: { 'User-Agent' => 'delicious-ruby 0.0.1' })
  end
end
