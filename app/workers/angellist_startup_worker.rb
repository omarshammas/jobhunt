class AngellistStartupWorker
  include Sidekiq::Worker

  def perform(company_name)
    company = Company.find_by(name: company_name)
    # if it does not exist, then why are we pulling in the angellist data
    return unless company


    company_slug = company_name.downcase.gsub(' ', '-')
    client = AngellistApi::Client.new
    angl_companies = client.startup_search slug: company_slug

    angl_company_id = angl_companies.id
    angl_company = client.get_startup angl_company_id

    # angellist quality attribute? - quality is an integer between 0 and 10, calculated every 48 hours, and reflects the company's rank on AngelList. Higher numbers mean better quality.
    %w{ logo_url thumb_url crunchbase_url
        angellist_quality
    }.each do |attribute|
      company.send("#{attribute}=", angl_company.send(attribute)) rescue nil
    end

    company.save!
  end

end
