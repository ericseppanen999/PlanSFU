# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

cmpt276 = Course.create(name: "CMPT 276", title: "Introduction to Software Engineering")
cmpt125 = Course.create(name: "CMPT 125", title: "Introduction to Computing Science and Programming II")
math150 = Course.create(name: "MATH 150", title: "Calculus I")

Section.create(section_number: "d300", course: cmpt276, instructor: "Steve Pearce", schedule: "MWF 10-11")
Section.create(section_number: "e100", course: cmpt125, instructor: "Victor Cheung", schedule: "TTh 9-10:30")
Section.create(section_number: "d100", course: math150, instructor: "Jamie Mulholland", schedule: "MWF 8:30-9:20")

CourseRelationship.create(course: cmpt276, related_course: cmpt125, relationship_type: 'prerequisite')
CourseRelationship.create(course: cmpt276, related_course: math150, relationship_type: 'prerequisite')
