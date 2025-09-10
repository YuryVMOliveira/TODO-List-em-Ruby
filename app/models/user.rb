class User < ApplicationRecord
    has_many :lists
    has_many :tasks
    has_secure_password
    validates :password, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } , length: { maximum: 255 } 
end
