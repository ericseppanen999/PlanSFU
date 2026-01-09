#!/usr/bin/env ruby
# Quick test script for the prerequisite parser
# Usage: cd lib/scripts && ruby test_parser.rb

require_relative "prerequisite_parser"

parser = PrerequisiteParser.new

test_cases = [
  {
    input: "CHEM 122 with a minimum grade of C-.",
    should_contain: ["CHEM 122 >= C-"],
    description: "Simple course with grade requirement"
  },
  {
    input: "MACM 101 or (ENSC 251 and one of MATH 232 or MATH 240).",
    should_contain: ["MACM 101", "ENSC 251", "MATH 232", "MATH 240"],
    description: "Complex nested OR/AND structure"
  },
  {
    input: "One of CMPT 102, 120, 126, 128 or 130 and one of MATH 150, 151, 154 or 157.",
    should_contain: ["CMPT 102", "MATH 150", "OR"],
    description: "Multiple OR groups with AND"
  },
  {
    input: "Minimum of 45 credits and a minimum CGPA of 2.50.",
    should_contain: ["CREDITS >= 45", "CGPA >= 2.50", "AND"],
    description: "Credit and GPA requirements"
  },
  {
    input: "CHEM 122, MATH 152, and PHYS 121, 126 or 141 (or PHYS 102 with a minimum grade of B), all with a minimum grade of C-.",
    should_contain: ["CHEM 122", "MATH 152", "PHYS 121"],
    description: "Multiple courses with complex structure"
  },
  {
    input: "BC Math 12 (or equivalent), or any of MATH 100, 150, 151, 154, 157.",
    should_not_contain: ["BC Math 12"],
    should_contain: ["MATH 100"],
    description: "Should ignore high school courses"
  },
  {
    input: "no prerequisite",
    expected: "#no_prereq_logic",
    description: "No prerequisite"
  },
  {
    input: "Permission of Instructor",
    expected: "#no_prereq_logic",
    description: "Permission only - should be ignored"
  },
  {
    input: "MATH 232 or MATH 240, with a minimum grade of C-.",
    should_contain: ["MATH 232", "MATH 240", "OR", ">= C-"],
    description: "OR group with grade requirement"
  },
  {
    input: "One W course and CMPT 276 with at least a B",
    should_contain: ["W_course", "CMPT 276 >= B"],
    description: "W course requirement"
  },
  {
    input: "CMPT 225 with a minimum grade of B+",
    should_contain: ["CMPT 225 >= B+"],
    description: "Grade with plus modifier"
  },
  {
    input: "MATH 100 or MATH 150 or MATH 151",
    should_contain: ["MATH 100", "MATH 150", "MATH 151", "OR"],
    description: "Multiple OR conditions"
  },
  {
    input: "CMPT 125 and CMPT 127, both with a minimum grade of C",
    should_contain: ["CMPT 125 >= C", "CMPT 127 >= C", "AND"],
    description: "Multiple courses with shared grade requirement"
  },
  {
    input: "Completion of 90 units and minimum CGPA of 3.0",
    should_contain: ["CREDITS >= 90", "CGPA >= 3.0", "AND"],
    description: "Credits and CGPA together"
  },
  {
    input: "MATH 150, 151, or 154",
    should_contain: ["MATH 150", "MATH 151", "MATH 154", "OR"],
    description: "Implied department in OR list"
  },
  {
    input: "PHYS 120 or 121 or 126 or 131",
    should_contain: ["PHYS 120", "PHYS 121", "PHYS 126", "PHYS 131", "OR"],
    description: "Multiple implied courses with OR"
  },
  {
    input: "CHEM 121 and (MATH 150 or MATH 151)",
    should_contain: ["CHEM 121", "MATH 150", "MATH 151", "OR", "AND"],
    description: "AND with nested OR in parentheses"
  },
  {
    input: "CMPT 225, MACM 201, and one of MATH 232 or MATH 240",
    should_contain: ["CMPT 225", "MACM 201", "MATH 232", "MATH 240", "OR", "AND"],
    description: "Multiple ANDs with one OR group"
  },
  {
    input: "Minimum of 60 credits toward a BSc degree",
    should_contain: ["CREDITS >= 60"],
    should_not_contain: ["BSc"],
    description: "Credits requirement with additional context"
  },
  {
    input: "ENSC 251 and (CMPT 125 or CMPT 127) and (MATH 232 or MATH 240)",
    should_contain: ["ENSC 251", "CMPT 125", "CMPT 127", "MATH 232", "MATH 240", "OR", "AND"],
    description: "Complex nested structure with multiple OR groups"
  },
  {
    input: "CMPT 300 with at least an A-",
    should_contain: ["CMPT 300 >= A-"],
    description: "High grade requirement with minus"
  },
  {
    input: "STAT 270 or STAT 285 or STAT 302",
    should_contain: ["STAT 270", "STAT 285", "STAT 302", "OR"],
    description: "Three-way OR"
  },
  {
    input: "MATH 152 or 155 or 158, and MATH 232 or 240",
    should_contain: ["MATH 152", "MATH 155", "MATH 158", "MATH 232", "MATH 240", "OR", "AND"],
    description: "Two OR groups connected with AND"
  },
  {
    input: "CMPT 125 with a minimum grade of C+ and CMPT 127 with a minimum grade of C+",
    should_contain: ["CMPT 125 >= C+", "CMPT 127 >= C+", "AND"],
    description: "Multiple courses with same grade requirement"
  },
  {
    input: "One of ENSC 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250",
    should_contain: ["ENSC 220", "ENSC 221", "OR"],
    description: "Very long OR list"
  },
  {
    input: "MATH 100 (may be taken concurrently)",
    should_contain: ["MATH 100"],
    should_not_contain: ["concurrently"],
    description: "Corequisite mention should be ignored"
  },
  {
    input: "Recommended: MATH 232",
    expected: "#no_prereq_logic",
    description: "Recommendation only - should be ignored"
  },
  {
    input: "Permission of the Department",
    expected: "#no_prereq_logic",
    description: "Permission only"
  },
  {
    input: "BC Pre-Calculus 12 or equivalent",
    expected: "#no_prereq_logic",
    description: "High school requirement only"
  },
  {
    input: "CMPT 125 >= C-",
    should_contain: ["CMPT 125 >= C-"],
    description: "Already formatted prerequisite"
  },
  {
    input: "MATH 100, 150, 151, 154, or 157, all with a minimum grade of C-",
    should_contain: ["MATH 100 >= C-", "MATH 150 >= C-", "MATH 151 >= C-", "MATH 154 >= C-", "MATH 157 >= C-", "OR"],
    description: "Long list with shared grade requirement"
  },
  {
    input: "CMPT 225 and MACM 201, both with a minimum grade of B",
    should_contain: ["CMPT 225 >= B", "MACM 201 >= B", "AND"],
    description: "Both with grade requirement"
  },
  {
    input: "Minimum CGPA of 2.67 (or permission of co-op co-ordinator)",
    should_contain: ["CGPA >= 2.67"],
    should_not_contain: ["permission", "co-op"],
    description: "CGPA with permission clause"
  },
  {
    input: "CMPT 125 and 127",
    should_contain: ["CMPT 125", "CMPT 127", "AND"],
    description: "Implied department for second course"
  },
  {
    input: "MATH 152 or 155 or 158, and MATH 232 or 240, and computing experience",
    should_contain: ["MATH 152", "MATH 155", "MATH 158", "MATH 232", "MATH 240", "OR", "AND"],
    should_not_contain: ["computing experience"],
    description: "Courses with non-course requirement"
  },
  {
    input: "CMPT 300W",
    should_contain: ["CMPT 300W"],
    description: "Course with W suffix"
  },
  {
    input: "One of CMPT 300W, 307, or 310",
    should_contain: ["CMPT 300W", "CMPT 307", "CMPT 310", "OR"],
    description: "OR group with W course"
  },
  {
    input: "CMPT 225 >= B+ AND MACM 201 >= C-",
    should_contain: ["CMPT 225 >= B+", "MACM 201 >= C-", "AND"],
    description: "Already parsed format"
  },
  {
    input: "",
    expected: "#no_prereq_logic",
    description: "Empty string"
  },
  {
    input: "   ",
    expected: "#no_prereq_logic",
    description: "Whitespace only"
  },
  {
    input: "CMPT 125 with a minimum grade of C- and a minimum CGPA of 2.50",
    should_contain: ["CMPT 125 >= C-", "CGPA >= 2.50", "AND"],
    description: "Course and CGPA requirement"
  }
]

puts "=" * 80
puts "Testing Prerequisite Parser"
puts "=" * 80
puts "\n"

passed = 0
failed = 0

test_cases.each_with_index do |test_case, index|
  puts "Test #{index + 1}: #{test_case[:description]}"
  puts "-" * 80
  puts "Input:    #{test_case[:input]}"
  
  result = parser.get_prereq_string(test_case[:input])
  puts "Output:   #{result}"
  
  # Check results
  test_passed = true
  
  if test_case[:expected]
    if result == test_case[:expected]
      puts "✅ PASSED - Exact match"
    else
      puts "❌ FAILED - Expected: #{test_case[:expected]}"
      test_passed = false
    end
  end
  
  if test_case[:should_contain]
    missing = test_case[:should_contain].reject { |str| result.include?(str) }
    if missing.empty?
      puts "✅ PASSED - Contains all required elements"
    else
      puts "❌ FAILED - Missing: #{missing.join(', ')}"
      test_passed = false
    end
  end
  
  if test_case[:should_not_contain]
    found = test_case[:should_not_contain].select { |str| result.include?(str) }
    if found.empty?
      puts "✅ PASSED - Correctly excludes elements"
    else
      puts "❌ FAILED - Should not contain: #{found.join(', ')}"
      test_passed = false
    end
  end
  
  if test_passed
    passed += 1
  else
    failed += 1
  end
  
  puts "\n"
end

puts "=" * 80
puts "Test Summary"
puts "=" * 80
puts "Total:  #{test_cases.length}"
puts "Passed: #{passed} ✅"
puts "Failed: #{failed} #{failed > 0 ? '❌' : ''}"
puts "=" * 80

exit(failed > 0 ? 1 : 0)
