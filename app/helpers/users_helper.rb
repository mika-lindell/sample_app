module UsersHelper

	# Returns Gravatar for given email (gravatar.com)
	def gravatar_for(user, options = { size: 70 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		# &d=mm param in URI changes the default profile pic if no image is associated to email address
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

end
