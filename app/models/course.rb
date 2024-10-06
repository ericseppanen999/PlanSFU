=begin
check if prerequisites are satisfied, works most of the time right now
fix: cannot handle grades with + or - sometimes
=end


require "digest"
class Course < ApplicationRecord
  self.primary_key = "unique_identifier"

  before_save :set_unique_identifier

  def prerequisites_satisfied?(completed_courses)
    completed_courses_hash = completed_courses.each_with_object({}) do |course, hash|
      # https://stackoverflow.com/questions/26634897/each-with-object-ruby-explanation
      identifier = "#{course['dept']} #{course['number']}"
      hash[identifier] = course["grade"]
    end

    evaluate_prerequisites(requisite_description, completed_courses_hash)
  end

  private

  def set_unique_identifier
    self.unique_identifier = generate_unique_identifier
  end

  # Method to generate unique identifier based on course attributes
  def generate_unique_identifier
    input_string = "#{year}-#{term}-#{dept}-#{number}"
    Digest::MD5.hexdigest(input_string)
  end

  def evaluate_prerequisites(prereq_string, completed_courses)
    # debug: print the prerequisite string
    puts "initial prerequisite string: #{prereq_string}"

    prereq_string = prereq_string.gsub(/\b(\w+ \d+) >= ([A-F][+-]?)\b/i) do |match|
      course_id, req = match.match(/\b(\w+ \d+) >= ([A-F][+-]?)\b/i).captures
      # https://apidock.com/ruby/String/gsub
      actual = completed_courses[course_id]

      result = if actual
                 grade_meets_requirement?(actual, req) ? "true" : "false"
      else
                 "false"
      end

      # debug: print each replacement
      puts "replacing '#{match}' with '#{result}' (actual grade: #{actual || 'not completed'})"
      result
    end

    prereq_string = prereq_string.gsub(/\bAND\b/i, "&&").gsub(/\bOR\b/i, "||")
    prereq_string = prereq_string.gsub(/[^truefalse&|() ]/, "")

    # debug
    puts "Final string to evaluate: #{prereq_string}"

    begin
      result = eval(prereq_string)
      # debug: print the evaluation result
      puts "Eval result: #{result}"
      result
    rescue SyntaxError, StandardError => e
      puts "eval error: #{e.message}"
      false
    end
  end

  def grade_meets_requirement?(actual, req)
    grade_order = %w[A+ A A- B+ B B- C+ C C- D F]
    reqi = grade_order.index(req)
    acti = grade_order.index(actual)

    # debug: print the comparison of grades
    puts "Comparing #{actual} (index #{acti}) to required #{req} (index #{reqi})"

    acti <= reqi
  end
end
