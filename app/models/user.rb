class User < ApplicationRecord

    has_and_belongs_to_many :boards, join_table: "boards_users"
    
    validates :username, uniqueness: true
    validates :username, :password, :name, presence: true
    validates :password, length: {minimum:8}

    before_create :generateToken

    def generateToken
        self.token = SecureRandom.urlsafe_base64
        return token
    end
end
