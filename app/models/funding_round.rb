class FundingRound < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :investors, -> { order(:name) }

  scope :order_by_most_recent, -> { order(announced_on: :desc) }
end
