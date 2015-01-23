json.array!(@companies) do |company|
  json.extract! company, :id, :name, :homepage_url, :short_description, :description, :founded_on, :headquarters, :is_closed, :is_acquired, :acquired_on, :acquired_by, :total_money_raised_usd
  json.url company_url(company, format: :json)
end
