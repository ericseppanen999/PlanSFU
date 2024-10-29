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

ActiveRecord::Schema[7.2].define(version: 2024_10_29_014122) do
  create_table "courses", id: false, force: :cascade do |t|
    t.string "dept", null: false
    t.string "number", null: false
    t.string "term", null: false
    t.string "year", null: false
    t.string "title"
    t.text "description"
    t.text "requisite_description"
    t.text "prereq_logic"
    t.text "short_description"
    t.integer "credits"
    t.json "instructors", default: []
    t.json "campuses", default: []
    t.json "delivery_methods", default: []
    t.json "sections", default: []
    t.json "requisites", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_identifier"
    t.index ["dept", "number", "term", "year"], name: "index_courses_on_dept_and_number_and_term_and_year", unique: true
    t.index ["unique_identifier"], name: "index_courses_on_unique_identifier", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "cas_user_id", null: false
    t.json "taken_courses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cas_user_id"], name: "index_users_on_cas_user_id", unique: true
  end
end
