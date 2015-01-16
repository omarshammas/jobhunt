class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :angellist_job_id
      t.string :job_type
      t.string :location
      t.string :role
      t.integer :salary_min
      t.integer :salary_max
      t.string :currency_code
      t.decimal :equity_min
      t.decimal :equity_max
      t.decimal :equity_cliff
      t.decimal :equity_vest
      t.boolean :remote_ok, default: false
      t.string :tags, array: true, default: []
      t.references :company, index: true

      t.timestamps null: false
    end
    add_foreign_key :jobs, :companies
  end
end
