class AddCompanyToFundingRound < ActiveRecord::Migration
  def change
    add_reference :funding_rounds, :company, index: true
    add_foreign_key :funding_rounds, :companies
  end
end
