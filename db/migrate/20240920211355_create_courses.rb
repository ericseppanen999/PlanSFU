class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses, id: false do |t|
      t.string :dept, null: false
      t.string :number, null: false
      t.string :title
      t.text :description
      t.text :requisite_description
      t.text :short_description
      t.integer :credits
      t.json :instructors, default: []
      t.json :campuses, default: []
      t.json :delivery_methods, default: []
      t.json :sections, default: []
      t.json :requisites, default: []
      t.integer :grade

      t.timestamps
    end
    add_index :courses, [ :dept, :number ], unique: true
  end
end
