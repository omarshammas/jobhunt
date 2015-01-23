class Company < ActiveRecord::Base
  has_many :funding_rounds, dependent: :destroy
  has_many :investors, -> { uniq.order(:name) }, through: :funding_rounds
  has_many :jobs, dependent: :destroy

  validates :name, presence: true

  before_save :calculate_total_money_raised

  def self.permaname name
    name.downcase.gsub(' ', '-')
  end
  def permaname
    self.class.permaname name
  end

private

  def calculate_total_money_raised
    self.total_money_raised_usd = funding_rounds.map do |funding_round|
                                             funding_round.money_raised_usd || 0
                                           end.inject(:+) || 0
  end

end
