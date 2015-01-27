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

ActiveRecord::Schema.define(version: 20150127061427) do

  create_table "groups", force: true do |t|
    t.integer  "qy_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "orders", force: true do |t|
    t.string "product_name"
    t.string "quantity"
    t.string "unit_price"
    t.string "total"
    t.string "cost_unit_price"
  end

  create_table "qy_apps", force: true do |t|
    t.string "name"
    t.string "qy_token"
    t.string "encoding_aes_key"
    t.string "corp_id"
    t.string "qy_secret_key"
  end

  add_index "qy_apps", ["corp_id"], name: "index_qy_apps_on_corp_id", using: :btree
  add_index "qy_apps", ["encoding_aes_key"], name: "index_qy_apps_on_encoding_aes_key", using: :btree
  add_index "qy_apps", ["qy_secret_key"], name: "index_qy_apps_on_qy_secret_key", using: :btree
  add_index "qy_apps", ["qy_token"], name: "index_qy_apps_on_qy_token", using: :btree

  create_table "users", force: true do |t|
    t.string   "userid"
    t.string   "deviceid"
    t.string   "position"
    t.string   "mobile"
    t.integer  "gender"
    t.string   "email"
    t.string   "weixinid"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.string   "name"
    t.string   "avatar"
    t.string   "department"
  end

end
