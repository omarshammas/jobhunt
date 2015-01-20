require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many(:funding_rounds).dependent(:destroy) }
  it { should have_many(:investors).through(:funding_rounds) }
  it { should have_many(:jobs).dependent(:destroy) }
  it { should validate_presence_of(:name) }

  it 'returns the company\'s permaname' do
    company = FactoryGirl.create :company, name: 'Expect Labs'
    expect(company.permaname).to eq('expect-labs')
    expect(Company.permaname 'Expect Labs').to eq('expect-labs')
  end
end
