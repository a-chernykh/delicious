RSpec.shared_examples 'api action' do
  it 'adds "Authorization: Bearer my-access-token" header' do
    action
    expect(WebMock).to have_requested(method, endpoint)
      .with(headers: { 'Authorization' => 'Bearer my-access-token' })
  end
end
