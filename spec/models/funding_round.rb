require 'rails_helper'

RSpec.describe FundingRound, type: :model do
  it { should belong_to(:company) }
end
