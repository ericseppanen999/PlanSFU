=begin
manages courserelationships
=end

class CourseRelationship < ApplicationRecord
  belongs_to :course
  belongs_to :related_course, class_name: "Course"
end
