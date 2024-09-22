eric seppanen personal docs

if rails console out of wack, rails db:rollback db:migrate db:seed
in cd, exit -> rails console

also, remove "GRADE"???

# course and grades
completed_courses = [
  { "dept" => "MACM", "number" => "101", "grade" => "C" },
  { "dept" => "CMPT", "number" => "125", "grade" => "C+" },
  { "dept" => "ENSC", "number" => "251", "grade" => "C-" },
  { "dept" => "ENSC", "number" => "252", "grade" => "C-" }
]

# also puts course.inspect
course = Course.find_by(dept: 'CMPT', number: '225')

if course&.prerequisites_satisfied?(completed_courses)
  puts "satisfied the prerequisites for #{course.dept} #{course.number}."
else
  puts "not satisfied the prerequisites for #{course.dept} #{course.number}."
end

Can't get over ruby using no return in functions

completed_courses = [
  { "dept" => "MACM", "number" => "101", "grade" => "C" },
  { "dept" => "CMPT", "number" => "225", "grade" => "C+" },
  { "dept" => "MATH", "number" => "151", "grade" => "C-" },
  { "dept" => "CMPT", "number" => "105", "grade" => "C-" }
]



## 2024/09/21 ## 
goto localhost/courses to see course list

if errors (should be good): 
rails tmp:clear 
rails assets:clobber

for armand
  added route in config/routes.rb
  created new view courses
  pull from db in any controller using @courses = Course.all (or Course.where(param))
  