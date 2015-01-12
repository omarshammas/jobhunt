require 'crunchbase'
Crunchbase::API.key = Rails.application.secrets.crunchbase_api_key
Crunchbase::API.debug = false
