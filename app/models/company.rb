class Company < ActiveRecord::Base
  has_many :funding_rounds, dependent: :destroy
  has_many :investors, -> { uniq.order(:name) }, through: :funding_rounds
  has_many :jobs, dependent: :destroy

  validates :name, presence: true
end
