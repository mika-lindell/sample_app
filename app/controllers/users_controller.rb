class UsersController < ApplicationController
  # What runs before any method in this controller
  # Logging is required to access these pages. Restricted to run only before edit and update
  before_filter :logged_in_user, only: [:index, :edit, :update]
  # Logged in user only makes sure that any user is logged in
  # This makes sure it's the correct user
  # Authentication = user is logged in, authorization = access rights to a specific object
  before_filter :correct_user,   only: [:edit, :update]
  # Restrict delete action only for admins
  before_filter :admin_user,     only: :destroy

  # Users listing
  def index
    @users = User.paginate(page: params[:page])
  end

  # Page to create new user
  def new
    if logged_in?
      # User who has logged in has no need to access create action
      redirect_to current_user
    else
      # Get ready to display signup page by declaring instance var
  	  @user = User.new
    end
  end

  # Action to create new user
  def create
    if logged_in?
      # User who has logged in has no need to access create action
      redirect_to current_user
    else 
      # Ready to create new user
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
  end

  # Page to show user
  def show
  	@user = User.find(params[:id])
    # Make microposts available for users show-action
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # Page to edit user
  def edit
    # @user is already set by correct_user
    # @user = User.find(params[:id])
  end
  
  # Action which edits (updates) user
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

  # Action which deletes user
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      # Make sure one can't delete his own profile
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  # Methods private for this class
  private
    # Defines what happens when one tries to edit profile of another user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
