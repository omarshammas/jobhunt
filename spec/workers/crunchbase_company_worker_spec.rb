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
    expect(AngellistStartupWorker.jobs.size).to eq(1)
    expect(AngellistStartupWorker).to have_enqueued_job('Expect Labs')
  end

  it 'tries to retrieve a startup that does not exist' do
    VCR.use_cassette('crunchbase/company-does-not-exit') do
      worker = CrunchbaseCompanyWorker.new
      worker.perform('Does Not Exist Company')
    end

    expect(Company.count).to eq(0)
    expect(AngellistStartupWorker.jobs.size).to eq(0)
  end

  describe 'hit the api limits' do
    let(:redis) { Redis.new }
    before(:each) do
      expect(Company.count).to eq(0)
      expect(CrunchbaseCompanyWorker.jobs.size).to eq(0)
    end
    it 'before the job' do
      # no vcr, because it shouldn't make any requests
      # job should reschedule itself immediately
      datetime_string = DateTime.now.to_s
      redis.set 'crunchbase-limit-hit', datetime_string
      CrunchbaseCompanyWorker.new.perform('Expect Labs')
      expect(redis.get('crunchbase-limit-hit')).to eq(datetime_string)
    end
    it 'during the job' do
      expect(redis.get('crunchbase-limit-hit')).to be nil
      VCR.use_cassette('crunchbase/company-api-limit') do
        worker = CrunchbaseCompanyWorker.new
        worker.perform('Expect Labs')
      end
      datetime_string = redis.get('crunchbase-limit-hit')
      expect(DateTime.now - DateTime.parse(datetime_string)).to be < 10
    end
    after(:each) do
      expect(Company.count).to eq(0)
      expect(CrunchbaseCompanyWorker.jobs.size).to eq(1)
      expect(CrunchbaseCompanyWorker).to have_enqueued_job('Expect Labs')
      expect(AngellistStartupWorker.jobs.size).to eq(0)
    end
  end
end
