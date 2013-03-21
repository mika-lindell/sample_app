class UsersController < ApplicationController
  # Page to create new user
  def new
  	@user = User.new
  end
  # Action to create new user
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
  # Page to show user
  def show
  	@user = User.find(params[:id])
  end
  # Page to edit user
  def edit
    @user = User.find(params[:id])
  end
  # Action that edits (updates) user
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
    else
      render 'edit'
    end
  end

end
