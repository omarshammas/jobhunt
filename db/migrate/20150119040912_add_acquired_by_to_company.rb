class AddAcquiredByToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :is_acquired, :boolean, default: false
    add_column :companies, :acquired_on, :date
    add_column :companies, :acquired_by, :string, default: ''
  end
end
