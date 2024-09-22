# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Sample courses data using JSON serialization
# Sample courses data
# Sample courses with requisites stored as dept and number pairs
Course.create!(
  dept: 'CMPT',
  number: '225',
  title: 'Data Structures and Programming',
  description: 'Introduction to data structures and algorithms.',
  requisite_description: '(MACM 101 >= C- AND (CMPT 125 >= C- OR CMPT 129 >= C- OR CMPT 135 >= C-)) OR (ENSC 251 >= C- AND ENSC 252 >= C-)',
  short_description: 'Covers data structures like stacks, queues, and trees.',
  credits: 3,
  instructors: [ 'D. Mitchell', 'Who Knows' ],
  campuses: [ 'Burnaby', 'Surrey' ],
  delivery_methods: [ 'In-person', 'Online' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: nil
)

Course.create!(
  dept: 'MATH',
  number: '151',
  title: 'Calculus I',
  description: 'A first course in calculus, covering limits, derivatives, and integrals.',
  requisite_description: 'Prerequisite: Pre-calculus 12 or equivalent.',
  short_description: 'Introduction to calculus concepts.',
  credits: 4,
  instructors: [ 'Jamie' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 85

)

Course.create!(
  dept: 'CMPT',
  number: '128',
  title: 'Introduction to Computing Science for Engineering Students',
  description: 'Introduction to computing science for engineering students.',
  requisite_description: 'Prerequisite: Pre-calculus 12 or equivalent.',
  short_description: 'Introduction to computing science.',
  credits: 3,
  instructors: [ 'Dr. Lee' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 90


)

Course.create!(
  dept: 'CMPT',
  number: '276',
  title: 'Introduction to Software Engineering',
  description: 'An overview of various techniques used for software development and software project management. Major tasks and phases in modern software development, including requirements, analysis, documentation, design, implementation, testing,and maintenance. Project management issues are also introduced. Students complete a team project using an iterative development process.',
  requisite_description: '(CMPT 105 >= C- AND CMPT 225 >= C- AND (MACM 101 >= C- OR (ENSC 251 >= C- AND ENSC 252 >= C-)) AND ((MATH 151 >= C- OR MATH 150 >= C-) OR (MATH 154 >= B+ OR MATH 157 >= B+)))',
  short_description: 'Introduction to software engineering.',
  credits: 3,
  instructors: [ 'Saba Alimadadi Jani', 'Parsa Rajabi', 'Steve Pearce', 'Herbert Tsang' ],
  campuses: [ 'Burnaby', 'Surrey' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 80
)


Course.create!(
  dept: 'CMPT',
  number: '300',
  title: 'Operating Systems I',
  description: 'Introduction to operating systems.',
  requisite_description: 'Prerequisite: CMPT 225.',
  short_description: 'Introduction to operating systems.',
  credits: 3,
  instructors: [ 'Dr. Lee' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 70
)



Course.create!(
  dept: 'CMPT',
  number: '354',
  title: 'Database Systems I',
  description: 'Introduction to database systems.',
  requisite_description: 'Prerequisite: CMPT 225.',
  short_description: 'Introduction to database systems.',
  credits: 3,
  instructors: [ 'Dr. Lee' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 75
)



Course.create!(
  dept: 'CMPT',
  number: '431',
  title: 'Computer Networks I',
  description: 'Introduction to computer networks.',
  requisite_description: 'Prerequisite: CMPT 300.',
  short_description: 'Introduction to computer networks.',
  credits: 3,
  instructors: [ 'Dr. Lee' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 85
)


Course.create!(
  dept: 'CMPT',
  number: '433',
  title: 'Computer Networks II',
  description: 'Advanced computer networks.',
  requisite_description: 'Prerequisite: CMPT 431.',
  short_description: 'Advanced computer networks.',
  credits: 3,
  instructors: [ 'Dr. Lee' ],
  campuses: [ 'Burnaby' ],
  delivery_methods: [ 'In-person' ],
  sections: [ 'd100', 'e100' ],
  requisites: [],
  grade: 90
)
