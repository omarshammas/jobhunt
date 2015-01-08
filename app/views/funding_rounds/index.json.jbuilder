json.array!(@funding_rounds) do |funding_round|
  json.extract! funding_round, :id, :funding_type, :money_raised_usd, :announced_on, :series
  json.url funding_round_url(funding_round, format: :json)
end
