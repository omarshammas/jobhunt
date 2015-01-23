class AddTotalMoneyRaisedUsdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :total_money_raised_usd, :integer
  end
end
