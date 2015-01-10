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

ActiveRecord::Schema.define(version: 20150108225111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "homepage_url"
    t.string   "short_description"
    t.text     "description"
    t.date     "founded_on"
    t.string   "headquarters"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
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

  add_foreign_key "funding_rounds", "companies"
end
