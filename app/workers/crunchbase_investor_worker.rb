class CrunchbaseInvestorWorker
  include Sidekiq::Worker

  def perform(investor_name)
    investor_permalink = investor_name.downcase.gsub(' ', '-')

    investments = Crunchbase::Investment.lists_for_permalink(investor_permalink)
    companies = investments.items.each do |investment|
      CrunchbaseCompanyWorker.perform_async investment.invested_in_name
    end
  end

end
