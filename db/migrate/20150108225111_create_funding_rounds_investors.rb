class CreateFundingRoundsInvestors < ActiveRecord::Migration
  def change
    create_table :funding_rounds_investors, id: false do |t|
      t.belongs_to :funding_round, index: true
      t.belongs_to :investor, index: true
    end
  end
end
