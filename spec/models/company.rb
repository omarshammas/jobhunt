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

  describe 'Total Money Raised' do
    before(:each) do
      @company = FactoryGirl.create :company
    end
    it 'company has no funding rounds' do
      expect(@company.total_money_raised_usd).to eq(0)
    end
    it 'company has 1 funding round but the amoun is not known' do
      @company.funding_rounds << FactoryGirl.create(:funding_round, funding_type: :seed, money_raised_usd: nil )
      @company.save!
      expect(@company.total_money_raised_usd).to eq(0)
    end
    it 'company has funding rounds but amount is only specifed in 1' do
      @company.funding_rounds << FactoryGirl.create(:funding_round, funding_type: :seed, money_raised_usd: nil )
      @company.funding_rounds << FactoryGirl.create(:funding_round, funding_type: :venture, money_raised_usd: 100000)
      @company.save!
      expect(@company.total_money_raised_usd).to eq(100000)
    end
  end
end
