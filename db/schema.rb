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

ActiveRecord::Schema[8.1].define(version: 2026_04_05_230225) do
  create_table "brands", force: :cascade do |t|
    t.string "country_of_origin", default: "Chile"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "candies", force: :cascade do |t|
    t.integer "brand_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "discontinued", default: false, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.integer "year_introduced"
    t.index ["brand_id"], name: "index_candies_on_brand_id"
    t.index ["category_id"], name: "index_candies_on_category_id"
    t.index ["discontinued"], name: "index_candies_on_discontinued"
    t.index ["slug"], name: "index_candies_on_slug", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  add_foreign_key "candies", "brands"
  add_foreign_key "candies", "categories"
end
