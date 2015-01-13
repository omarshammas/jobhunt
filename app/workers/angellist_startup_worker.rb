class AngellistStartupWorker
  include Sidekiq::Worker

  def perform(company_name)

    client = AngellistApi::Client.new
    startups = client.startup_search slug: company_name

    byebug
    startup_id = startups.first.id
    startup = client.get_startup startup_id

    byebug
    p "hello"

  end

end
