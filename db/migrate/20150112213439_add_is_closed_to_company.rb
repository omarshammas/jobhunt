class AddIsClosedToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :is_closed, :boolean, default: :false
  end
end
