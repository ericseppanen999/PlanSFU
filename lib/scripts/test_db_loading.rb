#!/usr/bin/env ruby
# Test database loading with a single course
# Usage: cd lib/scripts && ruby test_db_loading.rb

require_relative "../config/environment"
require_relative "prerequisite_parser"

# Test data - modify as needed
test_course = {
  dept: "TEST",
  number: "999",
  term: "spring",
  year: "2025",
  title: "Test Course for Parser Validation",
  description: "This is a test course to validate the prerequisite parser and database loading",
  requisite_description: "MATH 100 with a minimum grade of C- and minimum of 30 credits",
  credits: 3,
  instructors: ["Test Instructor"],
  campuses: ["Burnaby"],
  delivery_methods: ["In Person"],
  sections: ["d100"]
}

# Parse prerequisite
parser = PrerequisiteParser.new
test_course[:prereq_logic] = parser.get_prereq_string(test_course[:requisite_description]) || "#no_prereq_logic"

puts "=" * 80
puts "Testing Database Loading"
puts "=" * 80
puts "\nCourse Data:"
puts "-" * 80
test_course.each do |key, value|
  puts "#{key.to_s.ljust(25)}: #{value.inspect}"
end
puts "\nParsed Prerequisite Logic:"
puts "-" * 80
puts test_course[:prereq_logic]
puts "\n" + "=" * 80

begin
  # Check if course already exists
  existing = Course.find_by(
    dept: test_course[:dept],
    number: test_course[:number],
    term: test_course[:term],
    year: test_course[:year]
  )
  
  if existing
    puts "⚠️  Course already exists. Updating..."
    existing.update!(test_course)
    puts "✅ Course updated successfully"
    course = existing
  else
    puts "Creating new course..."
    course = Course.create!(test_course)
    puts "✅ Course created successfully"
  end
  
  puts "\nCourse Details:"
  puts "-" * 80
  puts "Unique ID:     #{course.unique_identifier}"
  puts "Department:    #{course.dept}"
  puts "Number:        #{course.number}"
  puts "Term:          #{course.term}"
  puts "Year:          #{course.year}"
  puts "Title:         #{course.title}"
  puts "Prereq Logic:  #{course.prereq_logic}"
  
  # Verify prerequisite logic was saved correctly
  if course.prereq_logic == test_course[:prereq_logic]
    puts "\n✅ Verification PASSED - prerequisite logic matches"
  else
    puts "\n❌ Verification FAILED"
    puts "Expected: #{test_course[:prereq_logic]}"
    puts "Got:      #{course.prereq_logic}"
  end
  
  # Test prerequisite evaluation (if you have taken courses)
  puts "\n" + "=" * 80
  puts "Testing Prerequisite Evaluation"
  puts "=" * 80
  
  # Example: test with empty taken courses
  taken_courses = []
  result = course.prerequisites_satisfied?(taken_courses, course.prereq_logic)
  puts "With no taken courses: #{result}"
  
  # Example: test with MATH 100 taken
  taken_courses = [
    { "dept" => "MATH", "number" => "100", "grade" => "B", "term" => "fall", "year" => "2024" }
  ]
  result = course.prerequisites_satisfied?(taken_courses, course.prereq_logic)
  puts "With MATH 100 (B): #{result}"
  
  puts "\n✅ All tests completed!"
  
rescue ActiveRecord::RecordInvalid => e
  puts "\n❌ Validation Error:"
  puts e.message
  puts "\nErrors:"
  e.record.errors.full_messages.each do |error|
    puts "  - #{error}"
  end
rescue => e
  puts "\n❌ Error: #{e.message}"
  puts "\nBacktrace:"
  puts e.backtrace.first(10).join("\n")
end

puts "\n" + "=" * 80
puts "Note: This test course can be deleted with:"
puts "Course.find_by(dept: 'TEST', number: '999').destroy"
puts "=" * 80
