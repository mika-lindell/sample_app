class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by_email(params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
      redirect_to user
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
