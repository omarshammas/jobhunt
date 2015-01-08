class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :homepage_url
      t.string :short_description
      t.text :description
      t.date :founded_on
      t.string :headquarters

      t.timestamps null: false
    end
  end
end
