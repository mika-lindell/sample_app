class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by_email(params[:email].downcase)
  	if user && user.authenticate(params[:password])
  		log_in user
      # Friendly forwarding
      # Makes sure user is forwarded to protected page he was trying to access prior login
      redirect_back_or root_url
  	else
  		# Create error message. 
  		# flash.now makes sure that message gets removed with render-call and not require http request for that
  		flash.now[:error] = 'Invalid email/password combination'
  		# Render login form
  		render 'new'
  	end

  end

  def destroy
  	log_out
    redirect_to root_url
  end

end
