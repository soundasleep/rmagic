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

ActiveRecord::Schema.define(version: 20150730053235) do

  create_table "action_log_targets", force: :cascade do |t|
    t.integer  "card_id",       null: false
    t.integer  "action_log_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "damage"
  end

  add_index "action_log_targets", ["action_log_id"], name: "index_action_log_targets_on_action_log_id"
  add_index "action_log_targets", ["card_id"], name: "index_action_log_targets_on_card_id"

  create_table "action_logs", force: :cascade do |t|
    t.integer  "card_id"
    t.string   "card_action"
    t.integer  "player_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "duel_id",       null: false
    t.string   "global_action"
    t.integer  "argument"
    t.integer  "phase_number"
  end

  add_index "action_logs", ["card_id"], name: "index_action_logs_on_card_id"
  add_index "action_logs", ["duel_id"], name: "index_action_logs_on_duel_id"
  add_index "action_logs", ["player_id"], name: "index_action_logs_on_player_id"

  create_table "battlefields", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.integer  "card_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "battlefields", ["card_id"], name: "index_battlefields_on_card_id", unique: true
  add_index "battlefields", ["player_id"], name: "index_battlefields_on_player_id"

  create_table "cards", force: :cascade do |t|
    t.integer  "metaverse_id",   null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "is_tapped",      null: false
    t.integer  "damage",         null: false
    t.integer  "turn_played",    null: false
    t.integer  "attached_to_id"
  end

  add_index "cards", ["attached_to_id"], name: "index_cards_on_attached_to_id"

  create_table "decks", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.integer  "card_id",    null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "decks", ["card_id"], name: "index_decks_on_card_id", unique: true
  add_index "decks", ["player_id"], name: "index_decks_on_player_id"

  create_table "declared_attackers", force: :cascade do |t|
    t.integer  "duel_id",          null: false
    t.integer  "card_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "target_player_id", null: false
    t.integer  "player_id",        null: false
  end

  add_index "declared_attackers", ["card_id"], name: "index_declared_attackers_on_card_id"
  add_index "declared_attackers", ["duel_id"], name: "index_declared_attackers_on_duel_id"
  add_index "declared_attackers", ["player_id"], name: "index_declared_attackers_on_player_id"
  add_index "declared_attackers", ["target_player_id"], name: "index_declared_attackers_on_target_player_id"

  create_table "declared_defenders", force: :cascade do |t|
    t.integer  "duel_id",    null: false
    t.integer  "source_id",  null: false
    t.integer  "target_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "declared_defenders", ["duel_id"], name: "index_declared_defenders_on_duel_id"
  add_index "declared_defenders", ["source_id"], name: "index_declared_defenders_on_source_id"
  add_index "declared_defenders", ["target_id"], name: "index_declared_defenders_on_target_id"

  create_table "duel_requests", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "premade_deck_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "duel_requests", ["premade_deck_id"], name: "index_duel_requests_on_premade_deck_id"
  add_index "duel_requests", ["user_id"], name: "index_duel_requests_on_user_id"

  create_table "duels", force: :cascade do |t|
    t.integer  "player1_id",                         null: false
    t.integer  "player2_id",                         null: false
    t.integer  "current_player_number",  default: 1, null: false
    t.integer  "phase_number",                       null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "priority_player_number", default: 1, null: false
    t.integer  "turn",                   default: 1, null: false
    t.integer  "first_player_number",    default: 1, null: false
    t.datetime "last_pass"
  end

  add_index "duels", ["player1_id"], name: "index_duels_on_player1_id"
  add_index "duels", ["player2_id"], name: "index_duels_on_player2_id"

  create_table "effects", force: :cascade do |t|
    t.integer  "effect_id",  null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "card_id",    null: false
  end

  add_index "effects", ["card_id"], name: "index_effects_on_card_id"
  add_index "effects", ["effect_id"], name: "index_effects_on_effect_id"
  add_index "effects", ["order"], name: "index_effects_on_order"

  create_table "graveyards", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.integer  "card_id",    null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "graveyards", ["card_id"], name: "index_graveyards_on_card_id", unique: true
  add_index "graveyards", ["player_id"], name: "index_graveyards_on_player_id"

  create_table "hands", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.integer  "card_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hands", ["card_id"], name: "index_hands_on_card_id", unique: true
  add_index "hands", ["player_id"], name: "index_hands_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "name",                              null: false
    t.boolean  "is_ai",             default: false, null: false
    t.integer  "life",              default: 20,    null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "mana_blue",         default: 0,     null: false
    t.integer  "mana_green",        default: 0,     null: false
    t.integer  "mana_red",          default: 0,     null: false
    t.integer  "mana_white",        default: 0,     null: false
    t.integer  "mana_black",        default: 0,     null: false
    t.integer  "mana_colourless",   default: 0,     null: false
    t.integer  "user_id"
    t.integer  "mulligans",         default: 0,     null: false
    t.boolean  "declared_mulligan", default: false, null: false
    t.boolean  "won",               default: false, null: false
    t.boolean  "lost",              default: false, null: false
    t.boolean  "drawn",             default: false, null: false
    t.decimal  "final_turn"
    t.datetime "last_action"
  end

  add_index "players", ["user_id"], name: "index_players_on_user_id"

  create_table "premade_deck_cards", force: :cascade do |t|
    t.integer  "premade_deck_id", null: false
    t.integer  "metaverse_id",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "premade_deck_cards", ["premade_deck_id"], name: "index_premade_deck_cards_on_premade_deck_id"

  create_table "premade_decks", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "created_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "premade_decks", ["created_by_id"], name: "index_premade_decks_on_created_by_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "stack_battlefield_targets", force: :cascade do |t|
    t.integer  "stack_id",   null: false
    t.integer  "target_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stack_battlefield_targets", ["stack_id"], name: "index_stack_battlefield_targets_on_stack_id"
  add_index "stack_battlefield_targets", ["target_id"], name: "index_stack_battlefield_targets_on_target_id"

  create_table "stack_graveyard_targets", force: :cascade do |t|
    t.integer  "stack_id",   null: false
    t.integer  "target_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stack_graveyard_targets", ["stack_id"], name: "index_stack_graveyard_targets_on_stack_id"
  add_index "stack_graveyard_targets", ["target_id"], name: "index_stack_graveyard_targets_on_target_id"

  create_table "stack_player_targets", force: :cascade do |t|
    t.integer  "stack_id",   null: false
    t.integer  "target_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stack_player_targets", ["stack_id"], name: "index_stack_player_targets_on_stack_id"
  add_index "stack_player_targets", ["target_id"], name: "index_stack_player_targets_on_target_id"

  create_table "stacks", force: :cascade do |t|
    t.integer  "duel_id",    null: false
    t.integer  "card_id",    null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "key",        null: false
    t.integer  "player_id",  null: false
  end

  add_index "stacks", ["card_id"], name: "index_stacks_on_card_id", unique: true
  add_index "stacks", ["duel_id"], name: "index_stacks_on_duel_id"
  add_index "stacks", ["player_id"], name: "index_stacks_on_player_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_ai",         default: false
  end

end
