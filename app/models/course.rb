## Course Model ##
# Creates a unique identifier for each course, using a hash of the term and course code.
# Also will contain a method to evaluate if a course's prerequisites are satisfied (Not complete as of 10/08/24)

require "digest"
class Course < ApplicationRecord
  # define the primary key
  self.primary_key = "unique_identifier"

  # define the relationships
  before_save :set_unique_identifier

  ## THE METHODS RELATIG TO PREREQUISITES ARE NOT COMPLETED ##
  # define the validations
  def prerequisites_satisfied?(completed_courses)
  end

  private

  # method to set unique identifier before saving
  def set_unique_identifier
    self.unique_identifier = generate_unique_identifier
  end

  # method to generate unique identifier based on course attributes using MD5 hash
  def generate_unique_identifier
    input_string = "#{year}-#{term}-#{dept}-#{number}"
    Digest::MD5.hexdigest(input_string)
  end

  def has_w(completed_courses)
    completed_courses.keys.each do |course|
      return true if course.end_with?("W")
    end
    false
  end

  def grade_meets_requirement?(actual, req)
  end

  def grade_to_value(grade)
    grade_scale = {
      "A+": 4.0, "A": 4.0, "A-": 3.7, "B+": 3.3, "B": 3.0, "B-": 2.7, "C+": 2.3, "C": 2.0, "C-": 1.7, "D": 1.0, "F": 0.0
    }
    grade_scale[grade]
  end
end
