class Company < ActiveRecord::Base
  has_many :funding_rounds
end
