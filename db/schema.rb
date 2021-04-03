# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_01_080840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.string "currency", default: "PLN"
    t.string "source"
    t.bigint "category_id"
    t.string "symbol"
    t.string "exchange"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "sterling"
    t.index ["category_id"], name: "index_assets_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "position_date_entries", force: :cascade do |t|
    t.bigint "position_id", null: false
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "PLN", null: false
    t.integer "exchange_value_cents", default: 0, null: false
    t.string "exchange_value_currency", default: "PLN", null: false
    t.float "amount"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position_id"], name: "index_position_date_entries_on_position_id"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.float "amount"
    t.date "open_date"
    t.integer "open_value_cents", default: 0, null: false
    t.string "open_value_currency", default: "USD", null: false
    t.integer "market_value_cents", default: 0, null: false
    t.string "market_value_currency", default: "USD", null: false
    t.string "hash_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_sync_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_positions_on_account_id"
    t.index ["asset_id"], name: "index_positions_on_asset_id"
  end

  add_foreign_key "position_date_entries", "positions"
  add_foreign_key "positions", "accounts"
  add_foreign_key "positions", "assets"
end
