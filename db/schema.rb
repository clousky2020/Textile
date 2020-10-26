# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_23_016557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.string "work_type"
    t.integer "work_id"
    t.integer "basic_wage", default: 0
    t.integer "minimun_wage", default: 0
    t.integer "house_allowance", default: 0
    t.integer "other_allowance", default: 0
    t.string "phone"
    t.string "bank_card"
    t.string "id_number"
    t.string "work_status"
    t.date "entry_date"
    t.date "daparture_date"
    t.date "birthday"
    t.string "address"
    t.string "email"
    t.string "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.string "specification"
    t.string "description"
    t.string "measuring_unit"
    t.bigint "purchase_supplier_id"
    t.decimal "preset_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "preset_price", precision: 8, scale: 2, default: "0.0"
    t.string "remarks"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["purchase_supplier_id"], name: "index_materials_on_purchase_supplier_id"
  end

  create_table "params", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "status", default: true
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "specification"
    t.string "measuring_unit"
    t.decimal "preset_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "preset_price", precision: 8, scale: 2, default: "0.0"
    t.string "remarks"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string "order_id"
    t.string "batch_number"
    t.string "description"
    t.bigint "purchase_supplier_id"
    t.bigint "material_id"
    t.bigint "repo_id"
    t.bigint "user_id"
    t.integer "number"
    t.string "measuring_unit"
    t.decimal "weight", precision: 8, scale: 1, default: "0.0"
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.decimal "tax_rate", precision: 4, scale: 3, default: "0.0"
    t.decimal "total_price", default: "0.0"
    t.integer "deposit", default: 0
    t.integer "freight", default: 0
    t.string "picture"
    t.string "check_status"
    t.boolean "check_result", default: false
    t.string "check_person"
    t.datetime "check_time"
    t.datetime "create_person"
    t.datetime "update_person"
    t.boolean "is_return", default: false
    t.boolean "status", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["material_id"], name: "index_purchase_orders_on_material_id"
    t.index ["order_id"], name: "index_purchase_orders_on_order_id"
    t.index ["purchase_supplier_id"], name: "index_purchase_orders_on_purchase_supplier_id"
    t.index ["repo_id"], name: "index_purchase_orders_on_repo_id"
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
  end

  create_table "purchase_suppliers", force: :cascade do |t|
    t.string "name"
    t.string "contacts"
    t.string "phone"
    t.string "address"
    t.string "description"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "description"
    t.bigint "user_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_repos_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sale_customers", force: :cascade do |t|
    t.string "name"
    t.string "contacts"
    t.string "phone"
    t.string "address"
    t.string "description"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sale_orders", force: :cascade do |t|
    t.string "order_id"
    t.string "description"
    t.bigint "sale_customer_id"
    t.bigint "product_id"
    t.bigint "repo_id"
    t.bigint "user_id"
    t.integer "number"
    t.string "measuring_unit"
    t.decimal "weight", precision: 10, scale: 1, default: "0.0"
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.decimal "tax_rate", precision: 4, scale: 3, default: "0.0"
    t.decimal "total_price", default: "0.0"
    t.integer "freight", default: 0
    t.string "picture"
    t.string "check_status"
    t.boolean "check_result", default: false
    t.string "check_person"
    t.datetime "check_time"
    t.datetime "create_person"
    t.datetime "update_person"
    t.boolean "is_return", default: false
    t.boolean "status", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_sale_orders_on_order_id"
    t.index ["product_id"], name: "index_sale_orders_on_product_id"
    t.index ["repo_id"], name: "index_sale_orders_on_repo_id"
    t.index ["sale_customer_id"], name: "index_sale_orders_on_sale_customer_id"
    t.index ["user_id"], name: "index_sale_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "email"
    t.bigint "employee_id"
    t.boolean "is_lock", default: false
    t.datetime "lock_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_users_on_employee_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
