require 'rails_helper'

RSpec.describe AngellistStartupWorker do

  it 'should retrieve the startup data using the angellist api' do
    VCR.use_cassette('angellist/company-expect-labs') do
      worker = AngellistStartupWorker.new
      worker.perform('Expect Labs')
    end

    # TODO
  end
end
