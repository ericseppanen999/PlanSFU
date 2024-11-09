## Course Model ##
# Creates a unique identifier for each course, using a hash of the term and course code.
# Also will contain a method to evaluate if a course's prerequisites are satisfied (Not complete as of 10/08/24)

require "digest"
class Course < ApplicationRecord
  # define the primary key
  self.primary_key = "unique_identifier"

  # define the relationships
  before_save :set_unique_identifier

  ## THE METHODS RELATING TO PREREQUISITES ARE NOT COMPLETED ##
  # define the validations
  def prerequisites_satisfied?(taken_courses, prereq_logic)
    return true if prereq_logic == "#no_prereq_logic"
    # logger.debug("Checking prerequisites for #{self.dept} #{self.number}")

    prereq_logic.gsub!("W_course >= C-", has_w(taken_courses).to_s)

    prereq_logic.gsub!(/([A-Z]+\s\d+[A-Z]*)\s*(>=)\s*([A-F][+-]?)/) do |match|
      course_code = Regexp.last_match(1)
      required_grade = Regexp.last_match(3)
      grade_meets_requirement?(taken_courses, course_code, required_grade).to_s
    end
    prereq_logic.gsub!("AND", "&&")
    prereq_logic.gsub!("OR", "||")
    begin
      Rails.logger.debug("Checking prerequisites for #{self.dept} #{self.number} == #{eval(prereq_logic)}")
      eval(prereq_logic)
    rescue Exception => e
      Rails.logger.debug("Error evaluating prerequisite logic: #{e.message}")
      false
    end
  end

  def user_eligible?(user)
    logger.debug("Checking eligibility for user #{user.cas_user_id} with #{user.taken_courses} . prereq_logic: #{self.prereq_logic}")
    prerequisites_satisfied?(user.taken_courses, self.prereq_logic)
  end

  private
  def set_unique_identifier
    self.unique_identifier = generate_unique_identifier
  end

  def generate_unique_identifier
    input_string = "#{year}-#{term}-#{dept}-#{number}"
    Digest::MD5.hexdigest(input_string)
  end

  def has_w(taken_courses)
    taken_courses.any? do |course|
      course["dept"].end_with?("W")
    end
  end

  def grade_meets_requirement?(taken_courses, course_code, required_grade)
    dept, number = course_code.split
    course = taken_courses.find { |c| c["dept"].upcase == dept.upcase && c["number"] == number }
    return false if course.nil?
    grade_to_value(course["grade"]) >= grade_to_value(required_grade)
  end

  def grade_to_value(grade)
    grade_scale = {
      "A+" => 12, "A" => 11, "A-" => 10, "B+" => 9, "B" => 8, "B-" => 7,
      "C+" => 6, "C" => 5, "C-" => 4, "D" => 3, "F" => 0
    }
    grade_scale[grade] || 0
  end
end
