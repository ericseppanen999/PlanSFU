## This script is used to generate course data from SFU's course outline API
# It can either write to seed files or directly load into the database
# Set LOAD_TO_DB=true to load directly into database

require "net/http"
require "json"
require "benchmark"
require "fileutils"
require "thread"
require "open3"
require_relative "prerequisite_parser"

# Load Rails environment if loading to database
if ENV["LOAD_TO_DB"] == "true" || ARGV.include?("--load-to-db")
  require_relative "../../config/environment"
  LOAD_TO_DATABASE = true
else
  LOAD_TO_DATABASE = false
end


def create_course(base_url)
  # create course, parameter: base_url
  sections_data = get_sections(base_url) # get sections data
  return unless sections_data # return if no sections data

  filtered_sections = filter_sections(sections_data) # filter sections data

  # initialize emptys
  instructors = []
  campuses = []
  delivery_methods = []
  prereq = nil
  desc = nil
  creds = nil

  # iterate through filtered sections
  filtered_sections.each_with_index do |section, index|
    section_url = build_url(base_url, section["value"]) # build section url
    section_info = get_section(section_url) # get section info

    # append to arrays
    instructors.concat(section_info[:instructors])
    campuses.concat(section_info[:campuses])
    delivery_methods.concat(section_info[:delivery_methods])

    if index == 0 # get course info from first section
      prereq = section_info[:prerequisite]
      desc = section_info[:description]
      creds = section_info[:credits]
    end
  end

  # remove duplicates
  instructors.uniq!
  campuses.uniq!
  delivery_methods.uniq!

  if LOAD_TO_DATABASE
    create_course_in_database(
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
  else
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
end

# append element to array
def rbappend(a, e)
  n = a.length
  newA = Array.new(a.length + 1)
  for i in 0..n
    newA[i] = a[i]
  end
  newA[n] = e
  newA
end

# get sections data
def get_sections(base_url)
  response = get_data_with_retries(base_url) # get data
  return unless response # return if no response
  JSON.parse(response)
rescue JSON::ParserError
  puts "json error in getsections: #{base_url}"
  nil
end

# check if string starts with letter
def starts_with(letter, string)
  string[0] == letter
end

# check if value is divisible by 100
def div_by_100(val)
  x = val[/\d+/].to_i
  x % 100 == 0
end

# check if value is less than 600
def less_than_600(val)
  x = val[/\d+/].to_i
  x < 600
end

# filter sections data
def filter_sections(secdata)
  secdata.select do |section|
    section_value = section["value"]
    if not starts_with("g", section_value) and (div_by_100(section_value) or starts_with("o", section_value)) # verify we have a valid section
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
  response = get_data_with_retries(section_url) # get data
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

def get_data_with_retries(url, max_retries = 3)
  retries = 0
  begin
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.open_timeout = 15 # Set the open timeout in seconds
    http.read_timeout = 15 # Set the read timeout in seconds

    response = http.get(uri.request_uri)
    if response.code.to_i == 200
      parsed_body = JSON.parse(response.body)

      if parsed_body.is_a?(Hash) && parsed_body["errorMessage"]
        puts "Error: #{parsed_body["errorMessage"]} at URL #{url}"
        nil
      else
        response.body
      end
    else
      puts "Response error in getdata #{url} with code #{response.code}"
      nil
    end
  rescue JSON::ParserError
    puts "Invalid JSON response from #{url}"
    nil
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    retries += 1
    puts "Timeout error when connecting to #{url}: #{e.message}. Retrying (Attempt #{retries})"
    if retries <= max_retries
      sleep(2**retries) # Exponential backoff
      retry
    else
      puts "Failed to fetch #{url} after #{max_retries} retries."
      nil
    end
  end
end
# get professor data
def get_profs(section_data)
  # map through instructor data to array
  section_data["instructor"]&.map { |instructor| instructor["name"] } || []
end

# get campus data
def get_campus(section_data)
  # map through campus data to array
  section_data["courseSchedule"]&.map { |schedule| schedule["campus"] } || []
end

# unnecessary method but kept for consistency and future use
# also dont want to hard code anything
def get_course_dept_term_year(url)
  parts = url.split("/")
  year = parts[-4].sub("course-outlines?", "")
  return parts[-1], parts[-2], parts[-3], year
end

def parse_prerequisites(input_string)
  if !input_string.nil? && input_string != "#no_prereq" && input_string != ""
    parser = PrerequisiteParser.new
    parsed_string = parser.get_prereq_string(input_string)
    parsed_string
  else
    nil
  end
end

# Create course directly in database with proper error handling
def create_course_in_database(first_section, filtered_sections, instructors, campuses, delivery_methods, prerequisite, description, credits, url)
  number, dept, term, year = get_course_dept_term_year(url)
  title = first_section["title"] || "n/a"
  prerequisite_logic = parse_prerequisites(prerequisite) || "#no_prereq_logic"

  # Escape strings for database
  course_data = {
    dept: dept.to_s,
    number: number.to_s,
    term: term.to_s,
    year: year.to_s,
    title: sanitize_string(title),
    description: sanitize_string(description || "no description available"),
    requisite_description: sanitize_string(prerequisite || "no prerequisite"),
    prereq_logic: prerequisite_logic.to_s,
    credits: credits,
    instructors: instructors || [],
    campuses: campuses || [],
    delivery_methods: delivery_methods || [],
    sections: filtered_sections.map { |section| section["value"] } || []
  }

  # Validate required fields
  unless course_data[:dept] && course_data[:number] && course_data[:term] && course_data[:year]
    puts "ERROR: Missing required fields for course: #{dept} #{number}"
    return false
  end

  # Check if course already exists
  existing_course = Course.find_by(
    dept: course_data[:dept],
    number: course_data[:number],
    term: course_data[:term],
    year: course_data[:year]
  )

  if existing_course
    # Update existing course
    begin
      existing_course.update!(course_data)
      puts "UPDATED: #{dept} #{number} (#{term} #{year})"
      true
    rescue ActiveRecord::RecordInvalid => e
      puts "ERROR updating #{dept} #{number}: #{e.message}"
      false
    end
  else
    # Create new course
    begin
      Course.create!(course_data)
      puts "CREATED: #{dept} #{number} (#{term} #{year})"
      true
    rescue ActiveRecord::RecordInvalid => e
      puts "ERROR creating #{dept} #{number}: #{e.message}"
      false
    rescue ActiveRecord::RecordNotUnique => e
      puts "ERROR: Duplicate course #{dept} #{number} (#{term} #{year})"
      false
    end
  end
rescue => e
  puts "ERROR processing course from #{url}: #{e.message}"
  puts e.backtrace.first(5).join("\n")
  false
end

# Sanitize string for database insertion
def sanitize_string(str)
  return "" if str.nil?
  # Remove null bytes and escape quotes
  str.to_s.gsub(/\0/, "").gsub(/"/, '\\"').gsub(/'/, "''")
end

def print_command(first_section, filtered_sections, instructors, campuses, delivery_methods, prerequisite, description, credits, url)
  # generate the command to seed our db
  number, dept, term, year = get_course_dept_term_year(url)
  title = first_section["title"] || "n/a"
  prerequisite_logic = parse_prerequisites(prerequisite) || "#no_prereq_logic"
  course_create_command = <<-RUBY
Course.create!(
  dept: "#{dept}",
  number: "#{number}",
  term: "#{term}",
  year: "#{year}",
  title: "#{title}",
  description: "#{description || "no description available"}",
  requisite_description: "#{prerequisite || "no prerequisite"}",
  prereq_logic:"#{prerequisite_logic || "#no_prereq_logic"}",
  credits: #{credits || "nil"},
  instructors: #{instructors.inspect},
  campuses: #{campuses.inspect},
  delivery_methods: #{delivery_methods.inspect},
  sections: #{filtered_sections.map { |section| section["value"] }.inspect}
)
  RUBY
  begin
    File.open("output.txt", "a") { |file| file.puts("#{dept} #{number}, #{term} #{year} : }") } # write into the file
  rescue IOError => e
    puts "Error writing to file: #{e}"
  end
  base_directory = "course_seed_data"
  # create directory if it doesn't exist with the specific name, year, and term
  folder_path = File.join(base_directory, year, term)
  FileUtils.mkdir_p(folder_path)
  file_name = "#{year}_#{term}_#{dept}_courses.txt"
  file_path = File.join(folder_path, file_name)

  begin
    File.open(file_path, "a") { |file| file.puts(course_create_command) } # write into the file
  rescue IOError => e
    puts "Error writing to file: #{e}"
  end
end

# scrape sfu rest api for all course data
def get_all_courses_with_retries(year, sem, dept, max_retries = 3)
  retries = 0
  begin
    url = URI("https://www.sfu.ca/bin/wcm/course-outlines?#{year}/#{sem}/#{dept}/")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    http.open_timeout = 15
    http.read_timeout = 15

    response = http.get(url.request_uri)
    if response.code.to_i != 200
      puts "dept: #{dept} failed with #{response.code}"
      return nil
    end

    JSON.parse(response.body)
  rescue JSON::ParserError
    puts "json error in get_all_courses: #{url}"
    nil
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    retries += 1
    puts "timeout error when connecting to #{url}: #{e.message}. Retrying (Attempt #{retries})"
    if retries <= max_retries
      sleep(2**retries) # Exponential backoff
      retry
    else
      puts "failed to fetch all courses for dept: #{dept} after #{max_retries} retries."
      nil
    end
  end
end

# Generate URLs and fetch data with retry mechanism integrated
def generate_url(year, sem, dept)
  courses = get_all_courses_with_retries(year, sem, dept)
  return if courses.nil?

  courses.each do |course|
    course_value = course["value"] rescue nil
    next if course_value.nil?

    if less_than_600(course_value) # we don't want grad courses
      course_url = "https://www.sfu.ca/bin/wcm/course-outlines?#{year}/#{sem}/#{dept}/#{course_value}/"
      create_course(course_url)
    end
  end
end

year_scope = [ "2022", "2023", "2024", "2025" ]
terms = [ "fall", "spring", "summer" ]
terms = [ "spring" ]
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

departments = [ "cmpt", "macm", "math", "ensc", "phys", "chem", "stat" ]

# departments = [ "cmpt", "macm", "math" ]

def times(year_scope, terms, departments)
  # puts "term:"
  # term = gets.chomp
  year = "2025"
  # term = "spring"
  total_time = Benchmark.measure do
    # threads = [] # threads for parralel processing
    # year_scope.each do |year|
    terms.each do |term|
      departments.each do |dept|
        # threads << Thread.new do
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
  end

  # threads.each(&:join) # wait for threads

  puts "year: #{year} term: #{term} total elapsed in: #{total_time.real}"
end

times(year_scope, terms, departments)
