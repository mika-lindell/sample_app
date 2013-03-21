class ApplicationController < ActionController::Base
  # Enable CSRF
  protect_from_forgery
  # Include this to enable sessions controller helper 
  # methods for all controllers.
  # Helpers are avaible for all views by default.
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    log_out
    super
  end

end
