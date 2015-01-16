require 'rails_helper'

RSpec.describe Job, type: :model do
  it { should belong_to(:company) }

  it 'returns the angellist url for the job' do
    job = FactoryGirl.create :job, angellist_job_id: nil
    expect(job.angellist_url).to be nil
    job.angellist_job_id = 42
    expect(job.angellist_url).to eq('https://angel.co/angellist/jobs/42')
  end
end
