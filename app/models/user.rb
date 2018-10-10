class User < ApplicationRecord
	attr_accessor :remember_token #use throughout class

	before_save { email.downcase! }
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	has_secure_password #rails method
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
  def self.digest(string) # min cost for testing, maximum for production for security
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
                                                  
    BCrypt::Password.create(string, cost: cost) #string = ps
  end

  def self.new_token
    SecureRandom.urlsafe_base64 #makes a random URl safe string, ruby method
  end

 # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    # updates remember digest column in db with the hashed version of the token
  end

  def authenticated?(remember_token)
  	return false if remember_digest.nil? #(to prevent bugs, if no token cause
  	#user logged out in another browser, return immediately so you don't get
  	# an error)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)

    # same as this unclear code: BCrypt::Password.new(remember_digest) == remember_token
  end

  def forget #sets remember digest in db to nil to forget user
    update_attribute(:remember_digest, nil)
  end

end
