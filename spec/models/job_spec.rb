require 'rails_helper'

RSpec.describe Job, type: :model do
  it { should belong_to(:company) }

  it 'returns the angellist url for the job' do
    company = FactoryGirl.create :company, name: 'Expect Labs'
    job = FactoryGirl.create :job, angellist_job_id: nil, company: company
    expect(job.angellist_url).to be nil
    job.angellist_job_id = 42
    expect(job.angellist_url).to eq('https://angel.co/expect-labs/jobs/42')
  end

  it 'returns the compensation summary' do
    job = FactoryGirl.build :job, salary_min: nil, salary_max: nil, equity_min: nil, equity_max: nil
    expect(job.compensation_summary).to eq('')

    job = FactoryGirl.build :job, salary_min: 100000, salary_max: 150000, equity_min: nil, equity_max: nil
    expect(job.compensation_summary).to eq('$ 100 K - 150 K')

    job = FactoryGirl.build :job, salary_min: nil, salary_max: nil, equity_min: BigDecimal.new("0.01"), equity_max: BigDecimal.new("0.2")
    expect(job.compensation_summary).to eq('0.01 - 0.2 %')

    job = FactoryGirl.build :job, salary_min: 100000, salary_max: 150000, equity_min: BigDecimal.new("0.01"), equity_max: BigDecimal.new("0.2")
    expect(job.compensation_summary).to eq('$ 100 K - 150 K  ·  0.01 - 0.2 %')
  end

  it 'setting the tags' do
    job = FactoryGirl.create :job, tags: []
    expect(job.tags).to eq([])

    job.update_attributes(tags: "")
    expect(job.tags).to eq([])

    job.update_attributes(tags: ['hello', 'there'])
    expect(job.tags).to eq(['hello', 'there'])

    job.update_attributes(tags: "hello buddy , there")
    expect(job.tags).to eq(['hello buddy', 'there'])
  end
end
