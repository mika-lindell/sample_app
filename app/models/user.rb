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

	# Associate user with followers, note use of foreign_key-param
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	# One should read :followed as 'followed_id' => Check 'Relationship'-model for enlightment
	# Note use of 'through'-param => We don't have full object data in db, just reference to certain user id
	has_many :followed_users, through: :relationships, source: :followed
	# We re-use Relationship-model under different name, 
	# and change primary key to followed_id, 
	# in order to return all users following certain user
	# Look for line starting with 'has_many :relationships' to understand what's going on.
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  # Look line above to understand.
  # One should read :follower as 'follower_id' => Check 'Relationship'-model for enlightment
	# Note use of 'through'-param =>  We don't have full object data in db, just reference to certain user id
  has_many :followers, through: :reverse_relationships, source: :follower

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

	def feed
    # This is preliminary. See "Following users" for the full implementation.
    # The question mark ensures that user submitted value 'id' is escaped 
    Micropost.where("user_id = ?", id)
  end

  # Check if we are following certain user
  # Note that we are using 'find_by_followed_id'-method, which looks only in followed_id column in 'ralationship'-model
	def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  # Make user to follow another
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

	# Make all methods after this to be visible only for this class
	private

	  def create_remember_token
	    # Create a token for 'forever' sessions
	    self.remember_token = SecureRandom.urlsafe_base64
	  end
end
