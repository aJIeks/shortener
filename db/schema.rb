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

ActiveRecord::Schema.define(version: 20150114112925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: true do |t|
    t.string   "key",          default: ""
    t.string   "url",          default: ""
    t.integer  "visits_count", default: 0
    t.string   "digest",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["digest"], name: "index_links_on_digest", unique: true, using: :btree
  add_index "links", ["key"], name: "index_links_on_key", unique: true, using: :btree

  create_table "visits", force: true do |t|
    t.integer  "link_id"
    t.datetime "visited_at"
    t.string   "referal",    default: ""
    t.inet     "ip",         default: "0.0.0.0"
  end

  add_index "visits", ["link_id"], name: "index_visits_on_link_id", using: :btree
  add_index "visits", ["visited_at"], name: "index_visits_on_visited_at", using: :btree

end
