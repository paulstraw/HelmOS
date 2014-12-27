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

ActiveRecord::Schema.define(version: 20141227093853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "factions", force: true do |t|
    t.string   "name",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_planet_id"
    t.string   "hex_color"
  end

  add_index "factions", ["home_planet_id"], name: "index_factions_on_home_planet_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "ship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "channel_name"
  end

  add_index "messages", ["ship_id"], name: "index_messages_on_ship_id", using: :btree

  create_table "planets", force: true do |t|
    t.string   "name"
    t.integer  "radius",     limit: 8
    t.integer  "star_id"
    t.integer  "apogee",     limit: 8
    t.integer  "perigee",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planets", ["star_id"], name: "index_planets_on_star_id", using: :btree

  create_table "satellites", force: true do |t|
    t.string   "name"
    t.integer  "orbitable_id"
    t.string   "orbitable_type"
    t.integer  "apogee",         limit: 8
    t.integer  "perigee",        limit: 8
    t.integer  "radius",         limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "satellites", ["orbitable_id", "orbitable_type"], name: "index_satellites_on_orbitable_id_and_orbitable_type", using: :btree

  create_table "ships", force: true do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faction_id"
    t.integer  "currently_orbiting_id"
    t.string   "currently_orbiting_type"
    t.boolean  "connected",               default: false, null: false
    t.integer  "travelling_to_id"
    t.string   "travelling_to_type"
    t.boolean  "travelling",              default: false, null: false
    t.datetime "travel_ends_at"
  end

  add_index "ships", ["captain_id"], name: "index_ships_on_captain_id", using: :btree
  add_index "ships", ["currently_orbiting_id", "currently_orbiting_type"], name: "index_ships_on_cur_orbiting_id_and_cur_orbiting_type", using: :btree
  add_index "ships", ["faction_id"], name: "index_ships_on_faction_id", using: :btree
  add_index "ships", ["travelling_to_id", "travelling_to_type"], name: "index_ships_on_travelling_to_id_and_travelling_to_type", using: :btree

  create_table "star_systems", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stars", force: true do |t|
    t.string   "name"
    t.integer  "x",              limit: 8
    t.integer  "y",              limit: 8
    t.integer  "star_system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "radius",         limit: 8
  end

  add_index "stars", ["star_system_id"], name: "index_stars_on_star_system_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",           null: false
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.string   "tg_auth_token",   null: false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
