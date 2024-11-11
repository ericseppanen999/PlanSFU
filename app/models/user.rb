class User < ApplicationRecord
  has_many :user_search_histories, dependent: :destroy
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  # Normalization
  normalizes :email, with: ->(email) { email.strip.downcase }

  # Token generation for password reset and email confirmation
  generates_token_for :password_reset do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email
  end

  private

  def password_required?
    new_record? || !password.nil? || !password_confirmation.nil?
  end
end