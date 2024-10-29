## This script is used to generate course data from SFU's course outline API and write it to a file
# The generated data can be used to seed the database with course data
# just a simple script, pretty readable.

require "net/http"
require "json"
require "benchmark"
require "fileutils"
require "thread"
require "open3"
require_relative "prerequisite_parser"


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
  response = get_data(base_url) # get data
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
  response = get_data(section_url) # get data
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

    if parsed_body.is_a?(Hash) && parsed_body["errorMessage"]
      puts "Error: #{parsed_body["errorMessage"]} at URL #{url}"
      nil
    else
      response.body
    end
  else
    puts "response error in getdata #{url} with code #{response.code}"
    nil
  end
rescue JSON::ParserError
  puts "Invalid JSON response from #{url}"
  nil
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

def print_command(first_section, filtered_sections, instructors, campuses, delivery_methods, prerequisite, description, credits, url)
  # generate the command to seed our db
  number, dept, term, year = get_course_dept_term_year(url)
  title = first_section["title"] || "n/a"
  short_description = description || "no short description"
  prerequisite_logic = parse_prerequisites(prerequisite) || "no prerequisite logic"

  course_create_command = <<-RUBY
Course.create!(
  dept: "#{dept}",
  number: "#{number}",
  term: "#{term}",
  year: "#{year}",
  title: "#{title}",
  description: "#{description || "no description available"}",
  requisite_description: "#{prerequisite || "no prerequisite"}",
  prereq_logic:"#{prerequisite_logic}", # implement
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
    next if course_value.nil?
    if less_than_600(course_value) # we don't want grad courses
      course_url = "https://www.sfu.ca/bin/wcm/course-outlines?#{year}/#{sem}/#{dept}/#{course_value}/"
      create_course(course_url)
    end
  end
end

year_scope = [ "2022", "2023", "2024", "2025" ]
terms = [ "fall", "spring", "summer" ]

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

departments = [ "cmpt", "macm", "math" ]

def times(year_scope, terms, departments)
  puts "year:"
  year = gets.chomp
  puts "term:"
  term = gets.chomp

  total_time = Benchmark.measure do
    # threads = [] # threads for parralel processing

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

  # threads.each(&:join) # wait for threads

  puts "year: #{year} term: #{term} total elapsed in: #{total_time.real}"
end

times(year_scope, terms, departments)
