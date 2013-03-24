class MicropostsController < ApplicationController
  # Make sure only logged in users have access to microposts
  before_filter :logged_in_user, only: [:create, :destroy]
  # Logged in user only makes sure that any user is logged in
  # This makes sure it's the correct user
  before_filter :correct_user,   only: :destroy
  def create
  	@micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # Supply empty array in case of failed creation: Home page expects this var to exist
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
      @micropost.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
