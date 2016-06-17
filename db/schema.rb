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

ActiveRecord::Schema.define(version: 20160617193126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string   "code",          null: false
    t.string   "name"
    t.string   "search_string", null: false
    t.integer  "city_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "airports", ["city_id"], name: "index_airports_on_city_id", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "departure_airport_id", null: false
    t.integer  "arrival_airport_id",   null: false
    t.integer  "price",                null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "alerts", ["arrival_airport_id"], name: "index_alerts_on_arrival_airport_id", using: :btree
  add_index "alerts", ["departure_airport_id"], name: "index_alerts_on_departure_airport_id", using: :btree
  add_index "alerts", ["user_id"], name: "index_alerts_on_user_id", using: :btree

  create_table "best_flights", force: :cascade do |t|
    t.integer  "departure_airport_id", null: false
    t.integer  "departure_city_id"
    t.integer  "arrival_airport_id",   null: false
    t.integer  "arrival_city_id"
    t.integer  "month",                null: false
    t.date     "departure_date",       null: false
    t.integer  "price",                null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "num_similar"
    t.string   "trip_string",          null: false
    t.boolean  "round_trip",           null: false
    t.string   "source",               null: false
    t.date     "return_date"
    t.integer  "trip_length",          null: false
  end

  add_index "best_flights", ["arrival_airport_id"], name: "index_best_flights_on_arrival_airport_id", using: :btree
  add_index "best_flights", ["departure_airport_id"], name: "index_best_flights_on_departure_airport_id", using: :btree
  add_index "best_flights", ["departure_date"], name: "index_best_flights_on_departure_date", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.integer  "departure_airport_id", null: false
    t.integer  "departure_city_id"
    t.integer  "arrival_airport_id",   null: false
    t.integer  "arrival_city_id"
    t.integer  "month",                null: false
    t.date     "full_date",            null: false
    t.integer  "price",                null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "flights", ["arrival_airport_id"], name: "index_flights_on_arrival_airport_id", using: :btree
  add_index "flights", ["departure_airport_id"], name: "index_flights_on_departure_airport_id", using: :btree
  add_index "flights", ["full_date"], name: "index_flights_on_full_date", using: :btree

  create_table "trips", force: :cascade do |t|
    t.integer  "departure_airport_id",                 null: false
    t.integer  "arrival_airport_id",                   null: false
    t.integer  "user_id",                              null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "alert",                default: false, null: false
    t.integer  "alert_price"
    t.string   "trip_string",                          null: false
  end

  add_index "trips", ["arrival_airport_id"], name: "index_trips_on_arrival_airport_id", using: :btree
  add_index "trips", ["departure_airport_id"], name: "index_trips_on_departure_airport_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "session_token",   null: false
    t.string   "default_airport"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
