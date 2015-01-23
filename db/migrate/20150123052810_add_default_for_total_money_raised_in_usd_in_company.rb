class AddDefaultForTotalMoneyRaisedInUsdInCompany < ActiveRecord::Migration
  def change
    change_column :companies, :total_money_raised_usd, :bigint, default: 0
  end
end
