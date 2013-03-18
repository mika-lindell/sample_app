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
#

class User < ActiveRecord::Base
	# Make these fields accessible outside activerecord
	attr_accessible :name, 
									:email, 
									:password, 
									:password_confirmation
	# Automagic for secure passw's
	# Remember correct names: password_digest, :password, :password_confirmation
	has_secure_password

	# Make lowercase emails before save for system compatibility
	before_save { email.downcase! }

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
						presence: true,
						 length: { minimum: 6 }
	validates :password_confirmation, presence: true
end
