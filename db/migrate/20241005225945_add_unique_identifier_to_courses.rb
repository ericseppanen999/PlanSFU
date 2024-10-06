class AddUniqueIdentifierToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :unique_identifier, :string
    add_index :courses, :unique_identifier, unique: true
  end
end
