module RequestHelper
  def parse_query(r)
    Hash[CGI.parse(r).map { |k, v| [k, v[0]] }]
  end

  def assert_param(request, param, value)
    params = parse_query(request.body)
    expect(params[param]).to eq value
  end
end
