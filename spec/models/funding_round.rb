require 'rails_helper'

RSpec.describe FundingRound, type: :model do
  it { should belong_to(:company) }
  it { should have_and_belong_to_many(:investors) }

  describe 'scopes' do
    it 'orders funding rounds by the most recent' do
      f1 = FactoryGirl.create :funding_round, announced_on: 1.month.ago
      f2 = FactoryGirl.create :funding_round, announced_on: 1.year.ago
      f3 = FactoryGirl.create :funding_round, announced_on: 1.day.ago

      expect(FundingRound.order_by_most_recent.pluck(:id)).to eq([f3.id, f1.id, f2.id])
    end
  end
end
