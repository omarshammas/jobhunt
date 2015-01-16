class AddUrlsAndQualityToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :logo_url, :string
    add_column :companies, :thumb_url, :string
    add_column :companies, :crunchbase_url, :string
    add_column :companies, :angellist_quality, :integer
  end
end
