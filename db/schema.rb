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

ActiveRecord::Schema.define(version: 20151202073733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "league_entries", force: :cascade do |t|
    t.string   "division"
    t.boolean  "is_fresh_blood"
    t.boolean  "is_hot_streak"
    t.boolean  "is_inactive"
    t.boolean  "is_veteran"
    t.integer  "league_points"
    t.integer  "losses"
    t.string   "mini_series"
    t.string   "player_or_team_id"
    t.string   "player_or_team_name"
    t.integer  "wins"
    t.integer  "summoner_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "league_entries", ["summoner_id"], name: "index_league_entries_on_summoner_id", using: :btree

  create_table "summoners", force: :cascade do |t|
    t.integer  "summoner_id"
    t.string   "name"
    t.string   "internal_name"
    t.integer  "profile_icon_id"
    t.integer  "revision_date"
    t.integer  "summoner_level"
    t.string   "region"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "summoners", ["internal_name"], name: "index_summoners_on_internal_name", using: :btree
  add_index "summoners", ["region"], name: "index_summoners_on_region", using: :btree
  add_index "summoners", ["summoner_id"], name: "index_summoners_on_summoner_id", using: :btree

  add_foreign_key "league_entries", "summoners"
end
