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

ActiveRecord::Schema.define(version: 20140309213820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.string   "queue"
    t.string   "tier"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_leagues", force: true do |t|
    t.boolean  "is_fresh_blood"
    t.boolean  "is_hot_streak"
    t.boolean  "is_inactive"
    t.boolean  "is_veteran"
    t.integer  "last_played"
    t.integer  "league_points"
    t.string   "mini_series"
    t.string   "player_or_team_id"
    t.string   "player_or_team_name"
    t.string   "queue_type"
    t.string   "rank"
    t.string   "tier"
    t.integer  "wins"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
  end

  add_index "player_leagues", ["player_id"], name: "index_player_leagues_on_player_id", using: :btree

  create_table "players", force: true do |t|
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
  add_index "players", ["summoner_id", "region"], name: "index_players_on_summoner_id_and_region", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
