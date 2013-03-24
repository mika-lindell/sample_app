module SessionsHelper
	# Create persistent session cookie and store user to variable
	def log_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  # Check if user is logged in to our site
  def logged_in?
  	# This line reads: if current user is not nil return true. Else return false.
  	!current_user.nil?
  end
  # Log out the user
  def log_out
  	self.current_user = nil
  	cookies.delete(:remember_token)
  end
  # Define what happens when we assign value to self.current_user
  def current_user=(user)
  	# We store it in instance variable
    @current_user = user
  end

  # Define what returns when we call current_user
	def current_user
		# We retrieve user based on the key stored in persistent session cookie
    # ||= operator adds assigned value to @current_user only if it's defined: It won't create it if it doesn't exist!
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  # Defines what happens when user tries to access restricted page
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, notice: "Please log in." unless logged_in?
    end
  end
  
  # Redirect to last requested URI
  def redirect_back_or(default)
    # Session variable is used unless it's nil.
    # When nil, the default-prametre is used
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # Store last requested URI by user (Not necessarily the page we currently on of there are redirects)
  def store_location

    session[:return_to] = request.url
  end
end