json.array!(@companies) do |company|
  json.extract! company, :id, :name, :homepage_url, :short_description, :description, :founded_on, :headquarters
  json.url company_url(company, format: :json)
end
