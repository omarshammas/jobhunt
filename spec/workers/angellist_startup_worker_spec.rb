require 'rails_helper'

RSpec.describe AngellistStartupWorker do

  it 'if the company does not exist then does not supplement with data from angelist api' do
    worker = AngellistStartupWorker.new
    worker.perform('Expect Labs')

    # nothing gets added
    expect(Company.count).to eq(0)
    #expect(Job.count).to eq(0)
  end

  it 'should retrieve the startup data using the angellist api' do
    company = FactoryGirl.create :company, name: 'Expect Labs'
    VCR.use_cassette('angellist/company-expect-labs') do
      worker = AngellistStartupWorker.new
      worker.perform('Expect Labs')
    end

    company.reload
    expect(company.crunchbase_url).to eq('http://www.crunchbase.com/company/expect-labs')
    expect(company.logo_url).to eq('https://d1qb2nb5cznatu.cloudfront.net/startups/i/39141-2a03ea2dda37a310d0226b4702a1069a-medium_jpg.jpg?buster=1349907202')
    expect(company.thumb_url).to eq('https://d1qb2nb5cznatu.cloudfront.net/startups/i/39141-2a03ea2dda37a310d0226b4702a1069a-thumb_jpg.jpg?buster=1349907202')
  end
end
