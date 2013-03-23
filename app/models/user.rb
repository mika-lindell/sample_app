# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	# Make these fields accessible outside activerecord
	# Note: these are also aceesible via URI! Super inmportant define waht you want to expose!
	# Without this request 'put /users/17?admin=1' would make user with id=17 admin!
	# Define attr_accessible for every model
	attr_accessible :name, 
									:email, 
									:password, 
									:password_confirmation
	# Automagic for secure passw's
	# Remember correct names: password_digest, :password, :password_confirmation
	has_secure_password

	# Associate user with multiple microposts and make sure microposts are destroyed with user
	has_many :microposts, dependent: :destroy

	# Make lowercase emails before save for system compatibility
	before_save { email.downcase! }
	before_save :create_remember_token

	# Validate name
	validates :name, 
						presence: true, 
						length: { maximum: 50 }
	
	# Create regexp constant and validate email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 
						presence: true, 
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
						# REMEMBER: UNIQUENESS IS NOT FOOLPROOF!
						# SEE TUTO SECTION 6.2.5

	# Validate passwords
	validates :password, 
						# presence: true, <= Removed to avoid duplicate message
						 length: { minimum: 6 }
	validates :password_confirmation, 
						presence: true
						
	# Make all methods after this to be visible only for this class
	private

	  def create_remember_token
	    # Create a token for 'forever' sessions
	    self.remember_token = SecureRandom.urlsafe_base64
	  end
end
