class User < ApplicationRecord
  has_many :user_search_histories, dependent: :destroy
  has_many :selected_courses, dependent: :destroy
  has_secure_password

  # Validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Normalize username
  before_save :normalize_username

  # Methods
  def course_history
    user_search_histories.order(created_at: :desc)
  end

  def save_course_selection(course_ids)
    selected_courses.where(course_id: course_ids).first_or_create!
  end

  def last_session_data
    {
      selected_courses: selected_courses.pluck(:course_id),
      recent_searches: course_history.limit(10),
      last_login: updated_at
    }
  end

  def self.find_by_token(token)
    return nil unless token
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    User.find(decoded["user_id"])
  rescue JWT::DecodeError
    nil
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def normalize_username
    self.username = username.strip.downcase
  end
end
