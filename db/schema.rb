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

ActiveRecord::Schema.define(version: 20151028142332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.string   "queue"
    t.string   "tier"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leagues", ["name"], name: "index_leagues_on_name", using: :btree
  add_index "leagues", ["queue"], name: "index_leagues_on_queue", using: :btree
  add_index "leagues", ["region"], name: "index_leagues_on_region", using: :btree
  add_index "leagues", ["tier"], name: "index_leagues_on_tier", using: :btree

  create_table "player_leagues", force: :cascade do |t|
    t.boolean  "is_fresh_blood"
    t.boolean  "is_hot_streak"
    t.boolean  "is_inactive"
    t.boolean  "is_veteran"
    t.integer  "last_played",         limit: 8
    t.integer  "league_points"
    t.string   "mini_series"
    t.string   "player_or_team_id"
    t.string   "player_or_team_name"
    t.string   "queue"
    t.string   "division"
    t.integer  "wins"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "league_id"
    t.integer  "losses"
  end

  add_index "player_leagues", ["division"], name: "index_player_leagues_on_division", using: :btree
  add_index "player_leagues", ["id", "updated_at", "is_inactive"], name: "index_player_leagues_on_id_and_updated_at_and_is_inactive", using: :btree
  add_index "player_leagues", ["league_id"], name: "index_player_leagues_on_league_id", using: :btree
  add_index "player_leagues", ["league_points"], name: "index_player_leagues_on_league_points", using: :btree
  add_index "player_leagues", ["player_id"], name: "index_player_leagues_on_player_id", unique: true, using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "summoner_id",     limit: 8
    t.string   "name"
    t.integer  "profile_icon_id"
    t.integer  "revision_date",   limit: 8
    t.integer  "summoner_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "region"
    t.string   "internal_name"
  end

  add_index "players", ["internal_name"], name: "index_players_on_internal_name", using: :btree
  add_index "players", ["region"], name: "index_players_on_region", using: :btree
  add_index "players", ["summoner_id"], name: "index_players_on_summoner_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "region"
  end

end
