class MicropostsController < ApplicationController
  # Make sure only logged in users have access to microposts
  # If you want to limit logged access to create and destroy only => before_filter :logged_in_user, only: [:create, :destroy]
  before_filter :logged_in_user

  def create
  	@micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
end
