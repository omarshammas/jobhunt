class Investor < ActiveRecord::Base
  has_and_belongs_to_many :funding_rounds
  has_many :companies, through: :funding_rounds
end
