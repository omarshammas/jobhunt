require 'rails_helper'

RSpec.describe CrunchbaseInvestorWorker do

  it 'should grab all the investments of the specified investor for processing' do
    VCR.use_cassette('crunchbase/investor-google-ventures') do
      worker = CrunchbaseInvestorWorker.new
      worker.perform('Google Ventures')
      expect(CrunchbaseCompanyWorker.jobs.size).to eq(324)
    end
  end

end
