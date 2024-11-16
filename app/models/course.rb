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
    # Rails.logger.debug("Checking prerequisites for #{self.dept} #{self.number} with #{taken_courses}")
    prereq_logic.gsub!("W_course >= C-", has_w(taken_courses).to_s)

    if prereq_logic.include?("CGPA") || prereq_logic.include?("CREDITS")
      gpa, credits = calculate_gpa(taken_courses)
    end

    prereq_logic.gsub!(/([A-Z]+\s\d+[A-Z]*)\s*(>=)\s*([A-F][+-]?)/) do |match|
      course_code = Regexp.last_match(1)
      required_grade = Regexp.last_match(3)
      grade_meets_requirement?(taken_courses, course_code, required_grade).to_s
    end

    prereq_logic.gsub!(/CREDITS\s*>=\s*(\d+)/) do
      required_credits = Regexp.last_match(1).to_i
      (credits >= required_credits).to_s
    end

    prereq_logic.gsub!(/CGPA\s*>=\s*(\d+(\.\d+)?)/) do
      required_cgpa = Regexp.last_match(1).to_f
      (gpa >= required_cgpa).to_s
    end

    prereq_logic.gsub!("AND", "&&")
    prereq_logic.gsub!("OR", "||")
    begin
      # Rails.logger.debug("Checking prerequisites for #{self.dept} #{self.number} == #{eval(prereq_logic)}")
      eval(prereq_logic)
    rescue Exception => e
      Rails.logger.debug("Error evaluating prerequisite logic: #{e.message}")
      false
    end
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

  def calculate_gpa(taken_courses)
    unique_identifiers = taken_courses.map { |course| course["unique_identifier"] }
    db_courses = Course.where(unique_identifier: unique_identifiers).index_by(&:unique_identifier)

    total_credits = 0
    total_grade_points = 0

    taken_courses.each do |course|
      db_course = db_courses[course["unique_identifier"]]
      next unless db_course&.credits

      grade_points = grade_to_value(course["grade"])
      total_grade_points += grade_points * db_course.credits
      total_credits += db_course.credits
    end

    gpa = total_credits.positive? ? (total_grade_points.to_f / total_credits) : 0
    [ gpa, total_credits ]
  end

  def grade_meets_requirement?(taken_courses, course_code, required_grade)
    dept, number = course_code.split

    matching_course = taken_courses.find do |course|
      course_dept = course["dept"].upcase
      course_number = course["number"]
      course_dept == dept.upcase && course_number == number
    end

    return false if matching_course.nil?

    actual_grade = grade_to_value(matching_course["grade"])
    required_grade = grade_to_value(required_grade)
    actual_grade >= required_grade
  end

  def grade_to_value(grade)
    grade_scale = {
      "A+" => 12, "A" => 11, "A-" => 10, "B+" => 9, "B" => 8, "B-" => 7,
      "C+" => 6, "C" => 5, "C-" => 4, "P" => 4, "D" => 3, "F" => 0
    }
    grade_scale[grade] || 0
  end
end
