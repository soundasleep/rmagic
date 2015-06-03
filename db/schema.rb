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

ActiveRecord::Schema.define(version: 20150603011650) do

  create_table "action_targets", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "damage"
  end

  add_index "action_targets", ["action_id"], name: "index_action_targets_on_action_id"
  add_index "action_targets", ["entity_id"], name: "index_action_targets_on_entity_id"

  create_table "actions", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "entity_action"
    t.integer  "player_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "duel_id"
  end

  add_index "actions", ["duel_id"], name: "index_actions_on_duel_id"
  add_index "actions", ["entity_id"], name: "index_actions_on_entity_id"
  add_index "actions", ["player_id"], name: "index_actions_on_player_id"

  create_table "battlefields", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "battlefields", ["entity_id"], name: "index_battlefields_on_entity_id"
  add_index "battlefields", ["player_id"], name: "index_battlefields_on_player_id"

  create_table "decks", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "entity_id"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "decks", ["entity_id"], name: "index_decks_on_entity_id"
  add_index "decks", ["player_id"], name: "index_decks_on_player_id"

  create_table "duels", force: :cascade do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "current_player"
    t.integer  "phase"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "duels", ["player1_id"], name: "index_duels_on_player1_id"
  add_index "duels", ["player2_id"], name: "index_duels_on_player2_id"

  create_table "entities", force: :cascade do |t|
    t.integer  "metaverse_id"
    t.integer  "token_type"
    t.integer  "effect_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "graveyards", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "entity_id"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "graveyards", ["entity_id"], name: "index_graveyards_on_entity_id"
  add_index "graveyards", ["player_id"], name: "index_graveyards_on_player_id"

  create_table "hands", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hands", ["entity_id"], name: "index_hands_on_entity_id"
  add_index "hands", ["player_id"], name: "index_hands_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_ai"
    t.integer  "life"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
