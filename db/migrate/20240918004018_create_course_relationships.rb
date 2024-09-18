class CreateCourseRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :course_relationships do |t|
      t.references :course, null: false, foreign_key: true
      t.references :related_course, null: false, foreign_key: true
      t.string :relationship_type

      t.timestamps
    end
  end
end
