class Company < ActiveRecord::Base
  has_many :funding_rounds, dependent: :destroy
  has_many :investors, -> { uniq.order(:name) }, through: :funding_rounds

  validates :name, presence: true
end
