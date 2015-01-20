class AngellistStartupWorker
  include Sidekiq::Worker

  def perform(company_name)
    company = Company.find_by(name: company_name)
    # if it does not exist, then why are we pulling in the angellist data
    return unless company


    company_slug = company.permaname
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


    angl_jobs = client.get_startup_jobs(angl_company_id)
    angl_jobs.each do |angl_job|
      job = Job.new
      job.angellist_job_id = angl_job.id
      %w{ title description job_type
          salary_min salary_max currency_code
          equity_min equity_max equity_cliff equity_vest
          remote_ok
      }.each do |attribute|
        job.send("#{attribute}=", angl_job.send(attribute)) rescue nil
      end

      # skils tags
      # role tag
      # location tag
      angl_job.tags.each do |angl_tag|
        job.tags << angl_tag.name       if angl_tag.tag_type == 'SkillTag'
        job.location = angl_tag.name    if angl_tag.tag_type == 'LocationTag'
        job.role = angl_tag.name        if angl_tag.tag_type == 'RoleTag'
      end

      company.jobs << job
    end

    company.save!
  end

end
