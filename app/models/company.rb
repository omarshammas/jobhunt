class Company < ActiveRecord::Base
  has_many :funding_rounds, dependent: :destroy
  has_many :investors, -> { uniq.order(:name) }, through: :funding_rounds
  has_many :jobs, dependent: :destroy

  validates :name, presence: true

  def self.permaname name
    name.downcase.gsub(' ', '-')
  end
  def permaname
    self.class.permaname name
  end

  def total_money_raised
    funding_rounds.map do |funding_round|
                    funding_round.money_raised_usd || 0
                  end.inject(:+) || 0
  end

end
