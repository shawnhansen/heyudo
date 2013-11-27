class AccountController < ApplicationController    

  model   :user
  before_filter :logged_in, :except => [:login, :signup, :confirmation, :confirmation_submit, :forgot_password, :forgot_password_submit, :reputation_whats_this, :privacy]

  def login
    case @request.method
      when :post
        if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])

          flash['notice']  = "Login successful"
          redirect_back_or_default :action => "welcome"
        else
          @login    = @params['user_login']
          @message  = "Wrong username or password"
      end
    end
  end
  
  def confirmation
    @user = User.find(@session['user'].id)
  end
  
  # Pulls user id and confirmation code entered on /account/confirmation.rhtml and
  # compares the code to the one generated on signup
  def confirmation_submit
    @user = User.find(params[:id])
      # If the confirmation code == the entry in the DB "confirmed is changed from 0 to 1
      if @user.conf_code == (params[:user]['conf_code'])
        @user.update_attribute("confirmed", 1)
        @session['user'].confirmed = 1
        @session[:first_login] = 1
        redirect_to :action => 'welcome'
      else
       flash[:notice] = "The code you entered was incorrect. Please go back and try again"
      end
  end
  
  # Re-sends signup email containing user's confirmation code to email address stored
  # in database
  def confirmation_resend
    @user = User.find(params[:user])
      # Emailer class, initiates sending of confirmation email
      Notifier::deliver_signup_thanks( @user )
          flash['notice']  = "Your confirmation code has been re-sent to your email address"
          redirect_back_or_default :action => "confirmation"
  end
  
  # Pulls the "ptp" field for user with the email address provided. Then emails the results to 
  # that email.
  def forgot_password_submit
    # Finds user based on email address entered
    @user = User.find(:first,
                      :conditions => [ '(email_address) = :email',
                                        {:email => params['user']['email_address']}])
    # If he email address entered is not found...
    if @user.nil?
      flash[:notice] = "Sorry, we didn't find the email address you entered"
      redirect_to :controller => 'account', :action => 'forgot_password'
    # If email address IS found and email is sent to the adress provided with the "ptp" value
    else
      flash[:notice] = "An email has been sent to you with your login information"
      Notifier::deliver_forgot_password( @user )
      redirect_to :controller => 'account', :action => 'login'
    end
  end
  
  # Creates inital account entry
  def signup
    # Finds a randomly selected code from the codes table in the DB 
    @conf_code = ((Time.now.to_i * 17) * (Time.now.to_i * 3)).to_s
    case @request.method
      when :post
        @user = User.new(@params['user'])
        @ptp = params['user']['password']
        @phone_number = params['area_code'] + params['exchange'] + params['last_four']
        # If the user entry was created successfully, "conf_code", "phone_number" and "ptp" 
        # are populated and the user is logged in.
        if @user.save
          @user.update_attribute("conf_code", @conf_code)
          @user.update_attribute("phone_number", @phone_number)
          @user.update_attribute("ptp", @ptp)      
          @session['user'] = User.authenticate(@user.login, @params['user']['password'])
          # Email is sent to the email address given including the confirmation code
          #Notifier::deliver_signup_thanks( @user )
          flash['notice']  = "Signup successful"
          redirect_back_or_default :action => "welcome"          
        end
      when :get
        @user = User.new
    end      
  end
    
  # Logout action. Clears the current session to nil then redirects to main/welcome page
  def logout
    @session['user'] = nil
    redirect_to :controller => 'main', :action => 'welcome'
  end
    
  # Gathers info from the DB to be displayed on /accout/welcome.rhtml
  def welcome
     # Checks the "confirmed" field for logged in user. If not confirmed (0), the user
     # is redirected to the confirmation page (/account/confirmation/rhtml)
     if @session['user'].confirmed == 0
      redirect_to :controller => 'account', :action => 'confirmation'
     end
     # Finds the current user's entry in the DB from the session and stores it as @user
     @user = User.find(@session['user'].id)

     # Determines the number of messages readable by the logged in user
     @num_messages = Message.find(:all, 
                                  :conditions => [ '(receiver_id) = :id AND (is_read) = 0',
                                                   {:id => @session['user'].id}])
                                                   
     # Determines the number of posts logged in user needs to pick a winner for
     @num_pending_posts = Post.find(:all, 
                                    :conditions => [ '(user_id) = :id AND end_date < :enddate AND lowest_bid > 0 AND winner = 0 AND delete_id = 0',
                                                     {:id => @session['user'].id, :enddate => Time.now}])
                                                     
     # Determines number of posts logged in user own that are eligable for feedback
     @num_feedback_posts = Post.find(:all, 
                                     :conditions => [ '(user_id) = :id AND end_date < :enddate AND (winner) > 0 AND left_feedback = 0 AND delete_id = 0 AND accepted = 1',
                                                      {:id => @session['user'].id, :enddate => Time.now}])
                                                      
     # Determines number of posts logged in user has won (selected as winner by post owner)
     @num_won_posts = Post.find(:all,
                                :conditions => [ '(winner) = :id AND (accepted) = 0 AND (bidder_delete_id) = 0',
                                                  {:id => @session['user'].id}])
                                    
  end
  
  # Displays messages relevant to logged in user
  def inbox_ajax
     # Finds all messages sent to logged in user's id
     @messages = Message.find(:all, 
                              :conditions => [ '(receiver_id) = :id ',
                                               {:id => @session['user'].id}],
                              :order => 'time_sent')
    render(:layout => false)                          
  end
  
  # Finds all posts relevant and owned by logged in user
  def your_posts_ajax
     # Finds all active posts for user id in current session
     @active_posts = Post.find(:all, 
                        :conditions => [ '(user_id) = :id AND end_date >= :enddate',
                                         {:id => @session['user'].id, :enddate => Time.now}],
                        :order => 'end_date')
                        
     # Finds all posts owned by logged in user that user needs to pick a winning bidder for
     @pending_posts = Post.find(:all, 
                                  :conditions => [ '(user_id) = :id AND end_date < :enddate AND lowest_bid > 0 AND winner = 0 AND delete_id = 0',
                                                   {:id => @session['user'].id, :enddate => Time.now}],
                                  :order => 'end_date')
                                  
     # Finds all posts owned by logged in user that eligable for feedback
     @completed_posts = Post.find(:all, 
                                    :conditions => [ '(user_id) = :id AND end_date < :enddate AND (winner) > 0 AND left_feedback = 0 AND delete_id = 0 AND accepted = 1',
                                                     {:id => @session['user'].id, :enddate => Time.now}],
                                    :include => :user,
                                    :order => 'end_date')
    render(:layout => false)
  end
  
  # Gathers posts for display of logged in user's active posts
  def active_posts_ajax
      # Finds all active posts for user id in current session
      @active_posts = Post.find(:all, 
                                 :conditions => [ '(user_id) = :id AND end_date >= :enddate',
                                                  {:id => @session['user'].id, :enddate => Time.now}],
                                 :order => 'end_date')
       render(:layout => false)
  end
  
  # Gathers data for display in "pick a winner" ajax display
  def pending_posts_ajax
       # Finds all posts owned by logged in user that user needs to pick a winning bidder for
       @pending_posts = Post.find(:all, 
                                   :conditions => [ '(user_id) = :id AND end_date < :enddate AND lowest_bid > 0 AND winner = 0 AND delete_id = 0',
                                                    {:id => @session['user'].id, :enddate => Time.now}],
                                   :order => 'end_date')
       render(:layout => false)
  end
  
  # Gathers data for display in "give feedback" ajax display
  def feedback_posts_ajax
      # Finds all posts owned by logged in user that eligable for feedback
      @completed_posts = Post.find(:all, 
                                    :conditions => [ '(user_id) = :id AND end_date < :enddate AND (winner) > 0 AND left_feedback = 0 AND accepted = 1',
                                                     {:id => @session['user'].id, :enddate => Time.now}],
                                    :include => :user,
                                    :order => 'end_date')
       render(:layout => false)
  end
  
  # Gathers data for display in "archived posts" ajax display
  def archived_posts_ajax
      # Finds user's posts that have expired and have a winner
      @archived_posts = Post.find(:all,
                                   :conditions => [ '(user_id) = :id AND end_date < :enddate AND (winner) > 0',
                                                     {:id => @session['user'].id, :enddate => Time.now}],
                                   :order => 'end_date')
       render(:layout => false)
  end
  
  # Finds all posts relevant and bid on by logged in user
  def your_bids_ajax
    # Determines number of posts that current user has won
     @won_posts_num = Post.find(:all,
                                :conditions => [ '(winner) = :id AND (accepted) = 0 AND (bidder_delete_id) = 0',
                                                  {:id => @session['user'].id}],
                                :order => 'end_date')
                                
     # Finds all of the posts the current user has bidded on, if any.
     @bidded_on = Bid.find(:all, 
                           :conditions => [ '(bids.user_id) = :id AND end_date >= :enddate',
                                        {:id => @session['user'].id, :enddate => Time.now}],
                           :include => :post,
                           :order => 'end_date')      
    render(:layout => false)
  end
  
  # Gathers posts for display of logged in user's active bids
  def active_bids_ajax
    # Finds all of the posts the current user has bid on, if any.
     @bidded_on = Bid.find(:all, 
                           :conditions => [ '(bids.user_id) = :id AND end_date >= :enddate',
                                        {:id => @session['user'].id, :enddate => Time.now}],
                           :include => :post,
                           :order => 'end_date')      
    render(:layout => false)
  end
  
  # Gathers posts for display in "posts you've won" ajax display
  def posts_you_won_ajax
    # Determines posts that current user has won
     @won_posts = Post.find(:all,
                                :conditions => [ '(winner) = :id AND (accepted) = 0 AND (bidder_delete_id) = 0',
                                                  {:id => @session['user'].id}],
                                :order => 'end_date')
     render(:layout => false)
  end
  
  # Gathers data for display in "archived wins" ajax display
  def your_archived_wins_ajax
    # Determines posts that current user has won
     @won_posts = Post.find(:all,
                                :conditions => [ '(winner) = :id',
                                                  {:id => @session['user'].id}],
                                :order => 'end_date')
     render(:layout => false)
  end
  
  # Gets initial data for display in account/settings
  def settings
    @user = User.find(params[:id])
    # Updates user's "opened_settings" attribute in DB to 1 to stop nag screen on dashboard
    @user.update_attribute("opened_settings", 1)
    render(:layout => false)
  end
  
  # Actual function for changing settings, from above
  def settings_save
    # User is found, then all fields from settings form are updated in the DB
    @user = User.find(params[:id])
    @user.update_attribute("pic", params[:user]['pic'])
    @user.update_attribute("user_info", params[:user]['user_info'])
    @user.update_attribute("site_url", params[:user]['site_url'])
      # Determines if user has uploaded a picture for their profile. If they have a CHMOD is 
      # performed to give all users read access to it
      if @user.pic.nil?
      else
      FileUtils.chmod 0644, @user.pic
      end
    flash[:notice] = "Your info had been updated sucessfully!"
    redirect_to :action => 'welcome'
  end
  
  # Finds a particular user and stores their data to be displayed on "public page"
  def show
    @user = User.find(params[:id])
    
    # Finds all active posts owned by the user
    @user_active_posts = Post.find(:all, 
                                   :conditions => [ '(user_id) = :id AND end_date >= :enddate',
                                                    {:id => @user.id, :enddate => Time.now}],
                                   :order => 'end_date')
    
    # Finds all feedback associated with the user
    @user_feedbacks = Feedback.find(:all,
                                    :conditions => [ '(bidder_id) = :id',
                                                     {:id => @user.id}],
                                    :order => 'sent')
  end
  
  # Empty action to suppress display of application layout (for ajax display)
  def reputation_whats_this
   
   render(:layout => false)
   
  end
  
  # Empty action to suppress display of application layout (for ajax display)
  def reputation_whats_this_prof_view
   
   render(:layout => false)
   
  end
  
end
