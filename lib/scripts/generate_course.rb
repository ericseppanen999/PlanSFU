require "net/http"
require "json"
require "benchmark"
require "fileutils"
require "thread"  # Import threading

# Initialize a counter for the total number of valid courses
$course_count = 0
$mutex = Mutex.new # Mutex to handle concurrency when updating global variables

def create_course(base_url)
  sections_data = get_sections(base_url)
  return unless sections_data

  filtered_sections = filter_sections(sections_data)

  instructors = []
  campuses = []
  delivery_methods = []
  prereq = nil
  desc = nil
  creds = nil

  filtered_sections.each_with_index do |section, index|
    section_url = build_url(base_url, section["value"])
    section_info = get_section(section_url)

    instructors.concat(section_info[:instructors])
    campuses.concat(section_info[:campuses])
    delivery_methods.concat(section_info[:delivery_methods])

    if index == 0
      prereq = section_info[:prerequisite]
      desc = section_info[:description]
      creds = section_info[:credits]
    end
  end

  instructors.uniq!
  campuses.uniq!
  delivery_methods.uniq!

  # Safely increment course count using a mutex for thread safety
  $mutex.synchronize { $course_count += 1 }

  print_command(
    sections_data.first,
    filtered_sections,
    instructors,
    campuses,
    delivery_methods,
    prereq,
    desc,
    creds,
    base_url
  )
end

def rbappend(a, e)
  n = a.length
  newA = Array.new(a.length + 1)
  for i in 0..n
    newA[i] = a[i]
  end
  newA[n] = e
  newA
end

def get_sections(base_url)
  response = get_data(base_url)
  return unless response
  JSON.parse(response)
rescue JSON::ParserError
  puts "json error in getsections: #{base_url}"
  nil
end

def starts_with(letter, string)
  string[0] == letter
end

def div_by_100(val)
  x = val[/\d+/].to_i
  x % 100 == 0
end

def less_than_600(val)
  x = val[/\d+/].to_i
  x < 600
end

def filter_sections(secdata)
  secdata.select do |section|
    section_value = section["value"]
    if not starts_with("g", section_value) and (div_by_100(section_value) or starts_with("o", section_value))
      true
    else
      false
    end
  end
end

def build_url(base_url, section_value)
  "#{base_url}#{section_value}"
end

def get_section(section_url)
  response = get_data(section_url)
  return { instructors: [], prerequisite: nil, campuses: [], delivery_methods: [], description: nil, credits: nil } unless response

  section_data = JSON.parse(response)
  {
    instructors: get_profs(section_data),
    prerequisite: section_data.dig("info", "prerequisites") || "#no_prereq",
    campuses: get_campus(section_data),
    delivery_methods: [ section_data.dig("info", "deliveryMethod") || "#no_deliverymethod" ],
    description: section_data.dig("info", "description") || "#no_description",
    credits: section_data.dig("info", "units")&.to_i || nil
  }
rescue JSON::ParserError
  puts "json error in getsection #{section_url}"
  { instructors: [], prerequisite: nil, campuses: [], delivery_methods: [], description: nil, credits: nil }
end

def get_data(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  if response.code.to_i == 200
    parsed_body = JSON.parse(response.body)

    # Check for error message in the response
    if parsed_body.is_a?(Hash) && parsed_body["errorMessage"]
      puts "Error: #{parsed_body["errorMessage"]} at URL #{url}"
      return nil
    else
      return response.body
    end
  else
    puts "response error in getdata #{url} with code #{response.code}"
    nil
  end
rescue JSON::ParserError
  puts "Invalid JSON response from #{url}"
  nil
end

def get_profs(section_data)
  section_data["instructor"]&.map { |instructor| instructor["name"] } || []
end

def get_campus(section_data)
  section_data["courseSchedule"]&.map { |schedule| schedule["campus"] } || []
end

def get_course_dept_term_year(url)
  parts = url.split("/")
  year = parts[-4].sub("course-outlines?", "")
  return parts[-1], parts[-2], parts[-3], year
end

def print_command(first_section, filtered_sections, instructors, campuses, delivery_methods, prerequisite, description, credits, url)
  number, dept, term, year = get_course_dept_term_year(url)
  title = first_section["title"] || "n/a"
  short_description = description || "no short description"

  course_create_command = <<-RUBY
Course.create!(
  dept: "#{dept}",
  number: "#{number}",
  term: "#{term}",
  year: "#{year}",
  title: "#{title}",
  description: "#{description || "no description available"}",
  requisite_description: "#{prerequisite || "no prerequisite"}",
  prereq_logic:"", # implement
  short_description: "#{short_description}",
  credits: #{credits || "nil"},
  instructors: #{instructors.inspect},
  campuses: #{campuses.inspect},
  delivery_methods: #{delivery_methods.inspect},
  sections: #{filtered_sections.map { |section| section["value"] }.inspect},
  requisites: [],
)
  RUBY

  base_directory = "course_seed_data"
  folder_path = File.join(base_directory, year, term)
  FileUtils.mkdir_p(folder_path)
  file_name = "#{year}_#{term}_#{dept}_courses.txt"
  file_path = File.join(folder_path, file_name)

  begin
    File.open(file_path, "a") { |file| file.puts(course_create_command) }
  rescue IOError => e
    puts "Error writing to file: #{e}"
  end
end

def get_all_courses(year, sem, dept)
  url = URI("https://www.sfu.ca/bin/wcm/course-outlines?#{year}/#{sem}/#{dept}/")
  response = Net::HTTP.get_response(url)
  if response.code.to_i != 200
    puts "dept: #{dept} failed with #{response.code}"
    return nil
  end
  JSON.parse(response.body)
rescue JSON::ParserError
  puts "json error in get_all_courses: #{url}"
  nil
end

def generate_url(year, sem, dept)
  courses = get_all_courses(year, sem, dept)
  return if courses.nil?

  courses.each do |course|
    course_value = course["value"] rescue nil
    next if course_value.nil? # Handle missing course value
    if less_than_600(course_value)
      course_url = "https://www.sfu.ca/bin/wcm/course-outlines?#{year}/#{sem}/#{dept}/#{course_value}/"
      create_course(course_url)
    end
  end
end

year_scope = ["2022", "2023", "2024", "2025"]
terms = ["fall", "spring", "summer"]

departments = [
  "acma", "als", "apma", "arab", "arch", "bisc", "bpk", "bus", "ca", "cenv",
  "chem", "chin", "cmns", "cmpt", "cogs", "crim", "data", "dial", "dmed", "easc",
  "econ", "edpr", "educ", "engl", "ensc", "env", "evsc", "fal", "fan", "fass",
  "fep", "fren", "ga", "geog", "germ", "gero", "grad", "grk", "gsws", "hist",
  "hsci", "hum", "iat", "indg", "inlg", "ins", "is", "ital", "japn", "lang",
  "lbrl", "lbst", "ling", "ls", "macm", "masc", "math", "mbb", "mse", "neur",
  "nusc", "onc", "phil", "phys", "plan", "plcy", "pol", "port", "psyc", "pub",
  "punj", "rem", "sa", "sci", "sd", "sda", "see", "span", "stat", "tekx",
  "ugrad", "urb", "wl"
]

def times(year_scope, terms, departments)
  puts "year:"
  year = gets.chomp
  puts "term:"
  term = gets.chomp

  total_time = Benchmark.measure do
    threads = [] # Store threads for parallel processing

    departments.each do |dept|
      threads << Thread.new do
        if year_scope.include?(year) and terms.include?(term) and departments.include?(dept)
          time = Benchmark.measure do
            generate_url(year, term, dept)
          end
          puts "dept: #{dept} elapsed in: #{time.real}"
        else
          puts "invalid input"
        end
      end
    end

    threads.each(&:join) # Wait for all threads to finish

    puts "year: #{year} term: #{term} total elapsed in: #{total_time.real}"
  end

  # Output total number of valid courses processed
  puts "Total number of valid courses processed: #{$course_count}"
end

times(year_scope, terms, departments)
