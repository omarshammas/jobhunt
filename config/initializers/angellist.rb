AngellistApi.configure do |config|
  config.access_token = Rails.application.secrets.angellist_api_key
end
