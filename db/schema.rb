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

ActiveRecord::Schema.define(version: 20180414160849) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_options", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.integer "option_id"
    t.index ["category_id", "option_id"], name: "index_categories_options_on_category_id_and_option_id"
  end

  create_table "categories_products", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.integer "product_id"
    t.index ["category_id", "product_id"], name: "index_categories_products_on_category_id_and_product_id"
  end

  create_table "option_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "option_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_options_on_option_type_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "option_id"
    t.integer "product_id"
    t.integer "type_value_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id", "product_id", "type_value_id"], name: "index_values_on_option_id_and_product_id_and_type_value_id"
  end

  create_table "varchar_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "option_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_varchar_values_on_option_id"
  end

end
