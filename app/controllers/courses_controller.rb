class CoursesController < ApplicationController
  # This action retrieves all courses from the database
  def index
    @courses = Course.all
  end

  # This action retrieves courses based on certain conditions (example: dept filter)
  def filter
    @courses = Course.where(dept: params[:dept]) # Adjust condition as needed
  end
end
