# Testing Guide for Course Generation Scripts

## Quick Tests

### 1. Test the Prerequisite Parser (Standalone)

Test the parser without database or API calls:

```bash
cd lib/scripts
ruby test_parser.rb
```

This will run through various test cases and show the parser output.

### 2. Test Parser with Real Examples

Test with actual prerequisite strings from your database:

```bash
cd lib/scripts
ruby -e "
require_relative 'prerequisite_parser'
parser = PrerequisiteParser.new

# Test with real examples
examples = [
  'CHEM 122 with a minimum grade of C-.',
  'MACM 101 or (ENSC 251 and one of MATH 232 or MATH 240).',
  'Minimum of 45 credits and a minimum CGPA of 2.50.',
  'One of CMPT 102, 120, 126, 128 or 130 and one of MATH 150, 151, 154 or 157.',
  'BC Math 12 (or equivalent), or any of MATH 100, 150, 151, 154, 157.',
  'no prerequisite',
  'Permission of Instructor'
]

examples.each do |input|
  result = parser.get_prereq_string(input)
  puts \"Input:  #{input}\"
  puts \"Output: #{result}\"
  puts \"-\" * 60
end
"
```

### 3. Test Database Loading (Small Scale)

**⚠️ WARNING: This will modify your database!**

Test with a single department and term first:

```bash
cd lib/scripts

# First, modify the script temporarily to test with just one department
# Edit generate_course.rb and change:
# departments = [ "cmpt" ]  # Just one department
# year_scope = [ "2025" ]    # Just one year
# terms = [ "spring" ]       # Just one term

# Then run with database loading enabled
LOAD_TO_DB=true ruby generate_course.rb
```

Or create a test script that loads just a few courses:

```bash
cd lib/scripts
ruby test_db_loading.rb
```

### 4. Test with Existing Seed Files

If you have existing seed files, you can test parsing them:

```bash
cd lib/scripts

# Parse a seed file and show prerequisite parsing
ruby -e "
require_relative 'prerequisite_parser'
parser = PrerequisiteParser.new

# Read a seed file
File.readlines('course_seed_data/2025/spring/2025_spring_macm_courses.txt').each do |line|
  if line.match(/requisite_description:\s*\"([^\"]+)\"/)
    req_desc = \$1
    parsed = parser.get_prereq_string(req_desc)
    puts \"Original: #{req_desc}\"
    puts \"Parsed:   #{parsed}\"
    puts \"-\" * 60
  end
end
"
```

## Comprehensive Testing

### Test 1: Parser Edge Cases

Create a file `test_parser_comprehensive.rb`:

```ruby
#!/usr/bin/env ruby
require_relative "prerequisite_parser"

parser = PrerequisiteParser.new

test_cases = [
  # Simple cases
  { input: "CHEM 122 with a minimum grade of C-.", 
    should_contain: ["CHEM 122 >= C-"] },
  
  # OR groups
  { input: "MATH 232 or MATH 240", 
    should_contain: ["MATH 232", "MATH 240", "OR"] },
  
  # Credit requirements
  { input: "Minimum of 45 credits", 
    should_contain: ["CREDITS >= 45"] },
  
  # GPA requirements
  { input: "Minimum CGPA 2.67", 
    should_contain: ["CGPA >= 2.67"] },
  
  # Complex nested
  { input: "MACM 101 or (ENSC 251 and one of MATH 232 or MATH 240)", 
    should_contain: ["MACM 101", "ENSC 251", "MATH 232", "MATH 240"] },
  
  # Should ignore
  { input: "BC Math 12 or MATH 100", 
    should_not_contain: ["BC Math 12"],
    should_contain: ["MATH 100"] },
  
  # No prerequisite
  { input: "no prerequisite", 
    expected: "#no_prereq_logic" },
]

puts "Running comprehensive parser tests..."
puts "=" * 80

test_cases.each_with_index do |test, i|
  puts "\nTest #{i + 1}:"
  puts "Input: #{test[:input]}"
  result = parser.get_prereq_string(test[:input])
  puts "Output: #{result}"
  
  if test[:expected]
    if result == test[:expected]
      puts "✅ PASSED"
    else
      puts "❌ FAILED - Expected: #{test[:expected]}"
    end
  elsif test[:should_contain]
    all_present = test[:should_contain].all? { |str| result.include?(str) }
    if all_present
      puts "✅ PASSED - Contains all required elements"
    else
      missing = test[:should_contain].reject { |str| result.include?(str) }
      puts "❌ FAILED - Missing: #{missing.join(', ')}"
    end
  end
  
  if test[:should_not_contain]
    none_present = test[:should_not_contain].none? { |str| result.include?(str) }
    if none_present
      puts "✅ PASSED - Correctly ignores excluded elements"
    else
      found = test[:should_not_contain].select { |str| result.include?(str) }
      puts "❌ FAILED - Should not contain: #{found.join(', ')}"
    end
  end
  
  puts "-" * 80
end
```

### Test 2: Database Loading with Validation

Create `test_db_loading.rb`:

```ruby
#!/usr/bin/env ruby
# Test database loading with a single course

require_relative "../config/environment"
require_relative "prerequisite_parser"

# Test data
test_course = {
  dept: "TEST",
  number: "999",
  term: "spring",
  year: "2025",
  title: "Test Course",
  description: "This is a test course",
  requisite_description: "MATH 100 with a minimum grade of C-",
  credits: 3,
  instructors: ["Test Instructor"],
  campuses: ["Burnaby"],
  delivery_methods: ["In Person"],
  sections: ["d100"]
}

# Parse prerequisite
parser = PrerequisiteParser.new
test_course[:prereq_logic] = parser.get_prereq_string(test_course[:requisite_description]) || "#no_prereq_logic"

puts "Testing database loading..."
puts "=" * 80
puts "Course data:"
puts test_course.inspect
puts "\nParsed prerequisite logic: #{test_course[:prereq_logic]}"
puts "\nAttempting to create course..."

begin
  # Check if exists
  existing = Course.find_by(
    dept: test_course[:dept],
    number: test_course[:number],
    term: test_course[:term],
    year: test_course[:year]
  )
  
  if existing
    puts "Course exists, updating..."
    existing.update!(test_course)
    puts "✅ Course updated successfully"
  else
    course = Course.create!(test_course)
    puts "✅ Course created successfully"
    puts "Unique ID: #{course.unique_identifier}"
  end
  
  # Verify
  verify = Course.find_by(
    dept: test_course[:dept],
    number: test_course[:number],
    term: test_course[:term],
    year: test_course[:year]
  )
  
  if verify && verify.prereq_logic == test_course[:prereq_logic]
    puts "✅ Verification passed - prerequisite logic matches"
  else
    puts "❌ Verification failed"
  end
  
rescue => e
  puts "❌ Error: #{e.message}"
  puts e.backtrace.first(5).join("\n")
end
```

### Test 3: API Fetching (Dry Run)

Test fetching from API without saving:

```bash
cd lib/scripts

# Modify generate_course.rb temporarily to add debug output
# Add puts statements in create_course_in_database to see what would be saved

# Run with a single department
ruby -e "
require_relative 'generate_course'

# Test fetching one course
url = 'https://www.sfu.ca/bin/wcm/course-outlines?2025/spring/cmpt/225/'
create_course(url)
"
```

## Rails Test Suite Integration

Create a proper Rails test file:

```bash
# Create test file
touch test/lib/prerequisite_parser_test.rb
```

Then add:

```ruby
require "test_helper"
require_relative "../../lib/scripts/prerequisite_parser"

class PrerequisiteParserTest < ActiveSupport::TestCase
  def setup
    @parser = PrerequisiteParser.new
  end

  test "parses simple course requirement" do
    result = @parser.get_prereq_string("CHEM 122 with a minimum grade of C-")
    assert_includes result, "CHEM 122 >= C-"
  end

  test "parses credit requirements" do
    result = @parser.get_prereq_string("Minimum of 45 credits")
    assert_includes result, "CREDITS >= 45"
  end

  test "parses GPA requirements" do
    result = @parser.get_prereq_string("Minimum CGPA 2.67")
    assert_includes result, "CGPA >= 2.67"
  end

  test "handles no prerequisite" do
    result = @parser.get_prereq_string("no prerequisite")
    assert_equal "#no_prereq_logic", result
  end

  test "ignores high school courses" do
    result = @parser.get_prereq_string("BC Math 12 or MATH 100")
    assert_not_includes result, "BC Math 12"
    assert_includes result, "MATH 100"
  end

  test "handles OR groups" do
    result = @parser.get_prereq_string("MATH 232 or MATH 240")
    assert_includes result, "MATH 232"
    assert_includes result, "MATH 240"
    assert_includes result, "OR"
  end
end
```

Run Rails tests:

```bash
bin/rails test test/lib/prerequisite_parser_test.rb
```

## Recommended Testing Workflow

1. **Start with parser tests** (no database/API):
   ```bash
   cd lib/scripts
   ruby test_parser.rb
   ```

2. **Test with real examples** from your seed files

3. **Test database loading** with a single test course:
   ```bash
   cd lib/scripts
   ruby test_db_loading.rb
   ```

4. **Test API fetching** with one department:
   - Modify `generate_course.rb` to limit to one dept
   - Run without `LOAD_TO_DB` first to see output
   - Then test with `LOAD_TO_DB=true` for a small dataset

5. **Full integration test**:
   - Use a test database
   - Run for one department, one term, one year
   - Verify courses are created correctly
   - Check prerequisite parsing accuracy

## Checking Results

After loading courses, verify in Rails console:

```bash
bin/rails console

# Check a specific course
course = Course.find_by(dept: "cmpt", number: "225", term: "spring", year: "2025")
puts course.prereq_logic

# Check parsing accuracy
Course.where("prereq_logic != '#no_prereq_logic'").limit(10).each do |c|
  puts "#{c.dept} #{c.number}: #{c.prereq_logic}"
end
```
