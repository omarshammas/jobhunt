# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150123052810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "homepage_url"
    t.string   "short_description"
    t.text     "description"
    t.date     "founded_on"
    t.string   "headquarters"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "is_closed",                        default: false
    t.string   "logo_url"
    t.string   "thumb_url"
    t.string   "crunchbase_url"
    t.integer  "angellist_quality"
    t.boolean  "is_acquired",                      default: false
    t.date     "acquired_on"
    t.string   "acquired_by",                      default: ""
    t.integer  "total_money_raised_usd", limit: 8, default: 0
  end

  create_table "funding_rounds", force: :cascade do |t|
    t.string   "funding_type"
    t.integer  "money_raised_usd"
    t.date     "announced_on"
    t.string   "series"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "company_id"
  end

  add_index "funding_rounds", ["company_id"], name: "index_funding_rounds_on_company_id", using: :btree

  create_table "funding_rounds_investors", id: false, force: :cascade do |t|
    t.integer "funding_round_id"
    t.integer "investor_id"
  end

  add_index "funding_rounds_investors", ["funding_round_id"], name: "index_funding_rounds_investors_on_funding_round_id", using: :btree
  add_index "funding_rounds_investors", ["investor_id"], name: "index_funding_rounds_investors_on_investor_id", using: :btree

  create_table "investors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.integer  "angellist_job_id"
    t.string   "job_type"
    t.string   "location"
    t.string   "role"
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.string   "currency_code"
    t.decimal  "equity_min"
    t.decimal  "equity_max"
    t.decimal  "equity_cliff"
    t.decimal  "equity_vest"
    t.boolean  "remote_ok",        default: false
    t.string   "tags",             default: [],                 array: true
    t.integer  "company_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "description"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "",    null: false
    t.string   "encrypted_password", default: "",    null: false
    t.integer  "sign_in_count",      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "funding_rounds", "companies"
  add_foreign_key "jobs", "companies"
end
