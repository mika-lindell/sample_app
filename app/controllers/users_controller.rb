class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
    	# Render signup page
      render 'new'
    end
  end

  def show
  	@user = User.find(params[:id])
  end
end
