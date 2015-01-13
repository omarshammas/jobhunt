class CrunchbaseCompanyWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  sidekiq_retry_in do |count|
    case count
    when 1..3
      1.min
    when 4
      1.hr
    else
      1.day
    end
  end

  # TODO - remove adelphic just used for
  # testing purposes now
  def perform(company_name)
    company = Company.find_by(name: company_name)
    # if it exists skip it, even though we should update it
    # but we have a limited number of api calls, so ignore
    # it for now
    return if company

    company_permalink = company_name.downcase.gsub(' ', '-')
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
  end

end
