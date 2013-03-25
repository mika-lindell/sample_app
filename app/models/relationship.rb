class Relationship < ActiveRecord::Base
	attr_accessible :followed_id

	# Because there is no model with name follower or followed, we need to define which class this belongs_to
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
