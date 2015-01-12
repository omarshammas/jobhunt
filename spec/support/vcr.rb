require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.hook_into :webmock # or :fakeweb
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = 'spec/vcr'
  config.filter_sensitive_data('<CRUNCHBASE_API_KEY>') { Rails.application.secrets.crunchbase_api_key }
end
