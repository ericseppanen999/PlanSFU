class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses, id: false do |t|
      t.string :dept, null: false
      t.string :number, null: false
      t.string :term, null: false
      t.string :year, null: false
      t.string :title
      t.text :description
      t.text :requisite_description
      t.text :prereq_logic
      t.text :short_description
      t.integer :credits
      t.json :instructors, default: []
      t.json :campuses, default: []
      t.json :delivery_methods, default: []
      t.json :sections, default: []
      t.json :requisites, default: []


      t.timestamps
    end
    add_index :courses, [ :dept, :number, :term, :year ], unique: true, name: "index_courses_on_dept_and_number_and_term_and_year"
  end
end
