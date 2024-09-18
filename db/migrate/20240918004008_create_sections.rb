class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.string :section_number
      t.references :course, null: false, foreign_key: true
      t.string :instructor
      t.string :schedule

      t.timestamps
    end
  end
end
