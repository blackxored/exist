module ApiHelpers
  def api_root
    @api_root ||= 'https://exist.io/api/1'
  end

  def stub_request_with_fixture(method, partial_url, fixture)
    stub_request(method, api_root + partial_url).to_return(
      body: File.read(fixture_path_for(fixture)),
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def fixture_path_for(name)
    File.expand_path("../../fixtures/#{name}.json", __FILE__)
  end
end

RSpec.configure do |config|
  config.include(ApiHelpers)
end
