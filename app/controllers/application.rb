# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency "login_system"
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include LoginSystem
  
  # Checks if user is logged in, if not redirects to login action
  def logged_in
    
    if session['user'].nil?
	 flash[:notice] = "Please Log In First"
	 redirect_to :controller => 'account', :action => 'login'
	end
	
  end
  
  # Checks to see if a user is placing a bid on their own post
  def self_bid
    @post = Post.find(params[:post])
      if session['user'].id == @post.user_id
        flash[:notice] = "Sorry, you can't bid on your own post :("
        redirect_to :controller => 'post', :action => 'show', :id => @post.id
      end      
  end
  
  # Check to see if bid entered is below the cap set by the poster
  def below_cap    
    @post = Post.find(params[:post])
    @bid = Bid.new(params[:bid])
      if @bid.amount > @post.cap
        flash[:notice] = "Sorry, your bid was higher than the limit set by the poster :("
        redirect_to :action => 'place', :post => @post.id
      end      
  end
  
  # Check for a bid entry of $0
  def zero_bid
    @bid = Bid.new(params[:bid])
      if @bid.amount < 1
        flash[:notice] = "You have enetered an invalid bid amount"
        redirect_to :action => 'place', :post => @post.id
      end
  end
  
  # Checks DB to see if "is_admin" is set to 0. Keeps the riff raff out of important areas
  def is_admin
    if @session['user'].is_admin == 0
    redirect_to :controller => 'account', :action => 'login'
    end
  end
  
end
