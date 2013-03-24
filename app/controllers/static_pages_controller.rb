class StaticPagesController < ApplicationController

  def home
    if logged_in?
    	# Create this var to make microposts model accessible 
    	@micropost = current_user.microposts.build 
      # Var which returns microposts in current page
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
