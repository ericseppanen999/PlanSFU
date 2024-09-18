=begin
manages different sections of course
=end

class Section < ApplicationRecord
  belongs_to :course
end
