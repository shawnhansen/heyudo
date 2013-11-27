class BidController < ApplicationController

before_filter :logged_in
before_filter :self_bid, :only => :completed
before_filter :zero_bid, :only => :completed

  # Stores post information for use with placing a bid
  # Finds relevant post and lowest bid for display on /bid/place.rhtml
  def place
    @post = Post.find(params[:post])
    # Finds lowest bid for the given post
    @bid_lowest = Bid.find(:first,
                           :conditions => [' (post_id) = :pid',
                                             {:pid => @post.id}],
                           :order => 'amount',
                           :limit => 1)
  end
  
  # Get's specified post info, creates a new bid instance, and writes it to the DB
  # Also updates lowes_bid in posts table with the bid amount using @post.update_attribute
  def completed
    @post = Post.find(params[:post])
    # Finds the current user's bid (if any) for the current post
    @bid_check = Bid.find(:first,
                          :conditions => [' (user_id) = :uid AND (post_id) = :pid',
                                            {:uid => @session['user'].id, :pid => @post.id}])
    # If no posts are found and assigned to @bid_check creates a new row in "bids"
    if @bid_check.nil?
      @bid = Bid.new(params[:bid])
      @bid.user_id = @session['user'].id
      @bid.post_id = @post.id
      @post.update_attribute("lowest_bid", @bid.amount) 
        if @bid.save
          if @bid.amount > @post.cap
          flash[:notice] = "Your bid was accepted, however it is higher than the what the poster specified as the most they'd be willing to pay"
          else
          flash[:notice] = "Your bid was placed successfully!"
          end
          redirect_to :controller => 'post', :action => 'show', :id => @post.id
        else
          flash[:notice] = "Something went horribly wrong...Just kidding, but you might want to try that again."
          redirect_to :controller => 'post', :action => 'show', :id => @post.id
        end
   else
     # If a result is found for @bid_check the "amount" is updated instead of a new
     # row being created
     @bid_check.update_attribute("amount", @bid.amount)
     if @bid.amount > @post.cap
          flash[:notice] = "Your bid was accepted, however it is higher than the what the poster specified as the most they'd be willing to pay"
     else
     flash[:notice] = "Your bid was placed successfully!"
     end
     redirect_to :controller => 'post', :action => 'show', :id => @post.id
   end
  end
  
  #Calculates amount due based on 4.99% of the amount accepted by the poster
  def accept
    @post_accepting = Post.find(params[:id])
    @payment_code = ((Time.now.to_i * 17) * (Time.now.to_i * 3)).to_s
    amt = (@post_accepting.winning_bid.to_i * 0.0499)
    @amount_due = ("%.2f" % amt)
    # Updates user's session to be processed upon returning after payment.
    session[:after_payment] = @post_accepting
    session[:payment_code] = @payment_code
    render(:layout => false)
  end
  
  # Verifies before payment session data then find the poster's info to be displayed
  def payment_complete
    @post = Post.find(params[:post_id])
    @user = User.find(@post.user_id)
    @payment_code = params[:cm]
    if @post.winner == @session['user'].id
      @receiver = User.find(@session['user'].id)
      @post.update_attribute("accepted", 1)
      # Emails posters info to bidder's email address before displaying
      Notifier::deliver_payment_complete( @receiver, @post, @user )
    else
      redirect_to :controller => 'account', :action => 'welcome'
    end
  end
  
  # Gathers poster's info to be redisplayed to the winning bidder at any time
  def review_contact_info
    @post = Post.find(params[:post])
    @user = User.find(@post.user_id)
      if @post.winner == @session['user'].id and @post.accepted == 1
      else
      redirect_to :controller => 'account', :action => 'welcome'
      end
  end

end 
