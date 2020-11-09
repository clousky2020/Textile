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

ActiveRecord::Schema.define(version: 2020_11_09_115334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id"
    t.boolean "up", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

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

  create_table "expenses", force: :cascade do |t|
    t.string "order_id"
    t.string "expense_type"
    t.string "counterparty"
    t.bigint "user_id"
    t.decimal "paper_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "actual_amount", precision: 10, scale: 2, default: "0.0"
    t.string "remark"
    t.string "account_number"
    t.string "account_name"
    t.string "account_from"
    t.string "picture"
    t.string "create_person"
    t.string "check_person"
    t.boolean "check_status", default: false
    t.datetime "check_time"
    t.datetime "bill_time"
    t.string "declare_invalid_person"
    t.boolean "is_invalid", default: false
    t.datetime "declare_invalid_time"
    t.boolean "need_reimburse", default: false
    t.boolean "reimbursed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "expenses_purchase_suppliers", id: false, force: :cascade do |t|
    t.bigint "expense_id"
    t.bigint "purchase_supplier_id"
    t.index ["expense_id"], name: "index_expenses_purchase_suppliers_on_expense_id"
    t.index ["purchase_supplier_id"], name: "index_expenses_purchase_suppliers_on_purchase_supplier_id"
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

  create_table "proceeds", force: :cascade do |t|
    t.string "order_id"
    t.bigint "sale_customer_id"
    t.bigint "user_id"
    t.decimal "paper_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "actual_amount", precision: 10, scale: 2, default: "0.0"
    t.string "remark"
    t.string "account_number"
    t.string "account_name"
    t.string "account_from"
    t.string "picture"
    t.string "create_person"
    t.string "check_person"
    t.boolean "check_status", default: false
    t.datetime "check_time"
    t.datetime "bill_time"
    t.string "declare_invalid_person"
    t.boolean "is_invalid", default: false
    t.datetime "declare_invalid_time"
    t.boolean "is_return", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sale_customer_id"], name: "index_proceeds_on_sale_customer_id"
    t.index ["user_id"], name: "index_proceeds_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "specification"
    t.string "measuring_unit"
    t.integer "turns_number"
    t.decimal "labor_cost", precision: 8, scale: 2, default: "0.0"
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
    t.string "create_person"
    t.string "check_person"
    t.boolean "check_status", default: false
    t.datetime "check_time"
    t.datetime "bill_time"
    t.string "declare_invalid_person"
    t.boolean "is_invalid", default: false
    t.datetime "declare_invalid_time"
    t.boolean "is_return", default: false
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
    t.decimal "check_money", precision: 10, scale: 2
    t.datetime "check_money_time"
    t.decimal "total_payment_required", precision: 10, scale: 2
    t.decimal "paid", precision: 10, scale: 2
    t.decimal "unpaid", precision: 10, scale: 2
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

  create_table "role_assignments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_role_assignments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "permissions"
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
  end

  create_table "sale_customers", force: :cascade do |t|
    t.string "name"
    t.string "contacts"
    t.string "phone"
    t.string "address"
    t.string "description"
    t.string "status"
    t.decimal "check_money", precision: 10, scale: 2
    t.datetime "check_money_time"
    t.decimal "total_collection_required", precision: 10, scale: 2
    t.decimal "received", precision: 10, scale: 2
    t.decimal "uncollected", precision: 10, scale: 2
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
    t.string "create_person"
    t.string "check_person"
    t.boolean "check_status", default: false
    t.datetime "check_time"
    t.datetime "bill_time"
    t.string "declare_invalid_person"
    t.boolean "is_invalid", default: false
    t.datetime "declare_invalid_time"
    t.boolean "is_return", default: false
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

  add_foreign_key "role_assignments", "roles"
  add_foreign_key "role_assignments", "users"
end
