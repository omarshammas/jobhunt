require 'rails_helper'

RSpec.describe FundingRound, type: :model do
  it { should belong_to(:company) }
  it { should have_and_belong_to_many(:investors) }
end
