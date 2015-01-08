class CreateFundingRounds < ActiveRecord::Migration
  def change
    create_table :funding_rounds do |t|
      t.string :funding_type
      t.integer :money_raised_usd
      t.date :announced_on
      t.string :series

      t.timestamps null: false
    end
  end
end
