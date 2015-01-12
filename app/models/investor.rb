class Investor < ActiveRecord::Base
  has_and_belongs_to_many :funding_rounds
  has_many :companies, -> { uniq.order(:name) }, through: :funding_rounds
end
