json.array!(@jobs) do |job|
  json.extract! job, :id, :title, :angellist_job_id, :job_type, :location, :role, :salary_min, :salary_max, :currency_code, :equity_min, :equity_max, :equity_cliff, :equity_vest, :remote_ok, :tags, :company_id, :description
  json.url job_url(job, format: :json)
end
