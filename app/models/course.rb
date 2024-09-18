=begin
manages course data and its relational connections to sections and other courses thru prereqs, coreqs
=end

class Course < ApplicationRecord
  has_many :sections

  has_many :course_relationships
  has_many :prerequisites, -> { where(course_relationships: { relationship_type: "prerequisite" }) },
  through: :course_relationships, source: :related_course
  has_many :corequisites, -> { where(course_relationships: { relationship_type: "corequisite" }) },
  through: :course_relationships, source: :related_course
  has_many :prereq_of, -> { where(course_relationships: { relationship_type: "prereq_of" }) },
  through: :course_relationships, source: :related_course
  has_many :coreq_of, -> { where(course_relationships: { relationship_type: "coreq_of" }) },
  through: :course_relationships, source: :related_course
end
