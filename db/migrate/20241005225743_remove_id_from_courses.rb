class RemoveIdFromCourses < ActiveRecord::Migration[7.2]
  def change
    remove_column :courses, :id, :integer
  end
end
