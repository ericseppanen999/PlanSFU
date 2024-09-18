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

ActiveRecord::Schema[7.2].define(version: 2024_09_18_004018) do
  create_table "course_relationships", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "related_course_id", null: false
    t.string "relationship_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_relationships_on_course_id"
    t.index ["related_course_id"], name: "index_course_relationships_on_related_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "section_number"
    t.integer "course_id", null: false
    t.string "instructor"
    t.string "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  add_foreign_key "course_relationships", "courses"
  add_foreign_key "course_relationships", "related_courses"
  add_foreign_key "sections", "courses"
end
