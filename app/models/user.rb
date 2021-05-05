class User < ApplicationRecord

    validates :username, uniqueness: true
    validates :username, :password, :name, presence: true
    validates :password, length: {minimum:8}

end
