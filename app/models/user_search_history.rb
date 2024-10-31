class UserSearchHistory < ApplicationRecord
  belongs_to :user

  # Validations
  validates :search_term, presence: true
end