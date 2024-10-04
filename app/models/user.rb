class User < ApplicationRecord
    has_many :user_search_histories, dependent: :destroy
    
    validates :email, presence: true, uniqueness: true
  end