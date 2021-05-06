class User < ApplicationRecord

    validates :username, uniqueness: true
    validates :username, :password, :name, presence: true
    validates :password, length: {minimum:8}

    before_create :generateToken

    def generateToken
        self.token = SecureRandom.urlsafe_base64
        return token
    end
end
