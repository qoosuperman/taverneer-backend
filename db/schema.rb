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

ActiveRecord::Schema[7.0].define(version: 202211116120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :publish_state, [
    "draft",
    "published",
    "unpublished",
  ], force: :cascade

  create_table "cocktails", force: :cascade do |t|
    t.string "name", null: false
    t.string "ancestry"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cocktails_on_name", unique: true
  end

  create_table "glasses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_glasses_on_name", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.string "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "cocktail_id", null: false
    t.bigint "glass_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "publish_state", default: "draft", null: false, enum_type: "publish_state"
    t.datetime "published_at", precision: nil
    t.index ["cocktail_id"], name: "index_recipes_on_cocktail_id"
    t.index ["glass_id"], name: "index_recipes_on_glass_id"
    t.index ["publish_state"], name: "index_recipes_on_publish_state"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "position", default: 0, null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "cocktails"
  add_foreign_key "recipes", "glasses"
  add_foreign_key "steps", "recipes"
end
