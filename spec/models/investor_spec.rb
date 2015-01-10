require 'rails_helper'

RSpec.describe Investor, type: :model do
  it { should have_and_belong_to_many(:funding_rounds) }
  it { should have_many(:companies) }
end
