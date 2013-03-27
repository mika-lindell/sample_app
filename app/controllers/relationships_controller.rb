class RelationshipsController < ApplicationController
	# Require user to be logged in for this controller
	before_filter :logged_in_user

  respond_to :html, :js

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_with @user
    #respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js # Respond to ajax requests
    #end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
    #respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js # Respond to ajax requests
    #end
  end
end
