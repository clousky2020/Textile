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

ActiveRecord::Schema.define(version: 2020_10_19_030747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
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
    t.string "remarks"
    t.string "role", default: "employee"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
