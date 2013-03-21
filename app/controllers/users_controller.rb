class UsersController < ApplicationController
  # What runs before any method in this controller
  # Restricted to run only before edit and update
  before_filter :logged_in_user, only: [:edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
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
    # @user is already set by correct_user
    # @user = User.find(params[:id])
  end
  # Action that edits (updates) user
  def update
    # @user is already set by correct_user
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      # log_in here makes sure token in cookie gets updated
      # If someone is using hijacked cookie, token gets updated and results in stole token not working
      log_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Methods private for this class
  private
    # Defines what happens when user tries to access restricted page
    def logged_in_user
      redirect_to login_url, notice: "Please log in." unless logged_in?
    end
    # Defines what happens when one tries to edit profile of another user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
