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

	validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # Associate micropost with single user
  belongs_to :user

  # Set ordering of microposts
  default_scope order: 'microposts.created_at DESC'
end
