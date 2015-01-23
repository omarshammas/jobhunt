class ChangeTotalMoneyRaisedUsdSizeinCompany < ActiveRecord::Migration
  def change
    change_column :companies, :total_money_raised_usd, :bigint
  end
end
