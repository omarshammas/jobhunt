require 'rails_helper'

RSpec.describe CrunchbaseCompanyWorker do

  it 'should retrieve the startup data using the crunchbase api' do
    VCR.use_cassette('crunchbase/company-expect-labs') do
      worker = CrunchbaseCompanyWorker.new
      worker.perform('Expect Labs')
    end

    expect(Company.count).to eq(1)
    company = Company.last
    expect(company.funding_rounds.size).to eq(4)
    expect(company.investors.size).to eq(13)
  end
end
