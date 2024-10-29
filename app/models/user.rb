class User < ApplicationRecord
    validates :cas_user_id, presence: true, uniqueness: true
end
