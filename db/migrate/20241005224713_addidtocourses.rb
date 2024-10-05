class Addidtocourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :id, :primary_key
  end
end
