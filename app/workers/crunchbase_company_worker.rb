class CrunchbaseCompanyWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  sidekiq_retry_in do |count|
    case count
    when 0..2
      1.min
    when 3
      1.hr
    else
      1.day
    end
  end

  def perform(company_name)
    company = Company.find_by(name: company_name)
    # if it exists skip it, even though we should update it
    # but we have a limited number of api calls, so ignore
    # it for now
    return if company

    # wait for the next batch cycle
    if api_limit_reached?
      schedule_in_next_batch(company_name)
      return
    end

    company_permalink = Company.permaname company_name
    cb_company = Crunchbase::Organization.get company_permalink

    company = Company.new

    %w{ name homepage_url
        short_description description
        founded_on is_closed
    }.each do |attribute|
      company.send("#{attribute}=", cb_company.send(attribute)) rescue nil
    end

    # headquarters
    # we aren't expecting multiple headquarters
    #organization.headquarters.each do |headquarter|
    #end
    headquarter = cb_company.headquarters.first
    company.headquarters = "#{headquarter.city}, #{headquarter.region}" if headquarter

    acquired_by = cb_company.acquired_by.try(:first)
    if acquired_by
      company.is_acquired = true
      company.acquired_by = acquired_by.name
      company.acquired_on = acquired_by.announced_on
    end

    cb_company.funding_rounds.map(&:permalink).each do |funding_round_permalink|
      cb_funding_round = Crunchbase::FundingRound.get funding_round_permalink

      funding_round = FundingRound.new
      %w{funding_type money_raised_usd
          announced_on series
      }.each do |attribute|
          funding_round.send("#{attribute}=", cb_funding_round.send(attribute)) rescue nil
      end

      # get investors, and associate it with
      cb_funding_round.investments.each do |cb_investment|
        investor = Investor.find_or_create_by(name: cb_investment.invested_in_name)
        funding_round.investors << investor
      end

      company.funding_rounds << funding_round
    end

    company.save!
    AngellistStartupWorker.perform_async(company_name)
  rescue Net::HTTPServerException # we've hit our api limit
    set_api_limit_reached
    schedule_in_next_batch company_name
  rescue Crunchbase::CrunchException => e
    # TODO - ignore and move on only if it is a 404 when a company is not found
    # but for now we're ignoring everything because
    # e.code does not exists and instead we must eval(e.message).code
    # and I'm not trying to run unknown code from crunchbase on the server

    # raise e unless e.code == '404'
  end

private

  # rate limits
  # - 50 Calls Per Min
  # - 2500 Calls Per Day
  # - 25000 Calls Per Month
  def set_api_limit_reached
    Sidekiq.redis do |conn|
      conn.set 'crunchbase-limit-hit', DateTime.now.to_s
    end
  end

  def api_limit_reached?
    datetime_string = nil
    Sidekiq.redis do |conn|
      datetime_string = conn.get 'crunchbase-limit-hit'
    end
    return false if datetime_string.blank?
    (DateTime.now.to_f - DateTime.parse(datetime_string).to_f) <= 60
  end

  def schedule_in_next_batch company_name
    CrunchbaseCompanyWorker.perform_in(1.minutes, company_name)
  end

end
