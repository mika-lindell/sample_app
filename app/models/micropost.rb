# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
	attr_accessible :content

	validates :content, presence: true, length: { maximum: MICROPOST_CONTENT_MAXLENGTH }
  validates :user_id, presence: true

  # Associate micropost with single user
  belongs_to :user

  # Set ordering of microposts
  default_scope order: 'microposts.created_at DESC'

  # Retrieve posts for personal feed
  # Own and follwed users posts
  def self.from_users_followed_by(user)
    # Prepare query syntax
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # Use 'IN' SQL-keyword to apply all the values in array to where query.
    # After 'OR' we ask for our own posts
    # We create hash in params and the use it to insert values into query 
    # Values are in method params to insert vars safely to query
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end

end
