class User < ActiveRecord::Base

	before_save { self.email = email.downcase }

	validates :first_name, presence: true, length: { maximum: 30 }
	validates :last_name, presence: true, length:  { maximum: 30 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format:{ with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :school, presence: true
	has_secure_password
	validates :password, length: { minimum: 6 }
end
