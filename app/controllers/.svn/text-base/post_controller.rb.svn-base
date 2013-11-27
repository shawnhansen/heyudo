class PostController < ApplicationController

  before_filter :logged_in, :except => [:show, :search, :show_search, :live_search, :total_active_posts, :browse, :browse_results]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  # Fetches requested post from the DB
  def show
    @post = Post.find(params[:id])
    
    # Finds a list of 4 lowest bids associated with current post
    @bids = Bid.find(:all,
                     :conditions => [ 'post_id = :pid',
                                       {:pid => @post.id}],
                     :order => 'amount',
                     :limit => 4)
                     
    # Finds other posts in the current post's city, limited to 5
    @other_posts = Post.find(:all, 
                             :conditions => [ '(city LIKE :post_city) AND end_date >= :enddate',
                                              {:post_city => @post.city, :enddate => Time.now}],
                             :limit => 5)
                             
    @meta_keywords = (@post.title).split
  end

  # Preps for new post creation. For non IE browsers
  def new
    # Checks the "confirmed" field for logged in user. If not confirmed (0), the user
    # is redirected to the confirmation page (/account/confirmation/rhtml)
    if @session['user'].confirmed == 0
      redirect_to :controller => 'account', :action => 'confirmation'
    end
    @post = Post.new
    render(:layout => false)
  end
  
  # Preps for new post for IE browsers
  def new_IE
    # Checks the "confirmed" field for logged in user. If not confirmed (0), the user
    # is redirected to the confirmation page (/account/confirmation/rhtml)
    if @session['user'].confirmed == 0
      redirect_to :controller => 'account', :action => 'confirmation'
    end
    @post = Post.new
    render(:layout => false)
  end

  # Records new post and all paramaters to DB
  def create
    @post = Post.new(params[:post])
    #pulls user's id from session to write in "user_id" for "posts" table
    @post.user_id = @session['user'].id
    if @post.save
      # Checks all 3 picture upload slots. If a picture was uploaded it is CHMODed to 644 to 
      # allow all users read access
      if @post.pic_1.nil?
      else
      FileUtils.chmod 0644, @post.pic_1
      end
      if @post.pic_2.nil?
      else
      FileUtils.chmod 0644, @post.pic_2
      end
      if @post.pic_3.nil?
      else
      FileUtils.chmod 0644, @post.pic_3
      end
      # Determines which post was just created for a redirect after creation
      @redirect_post = Post.find(:first,
                                 :conditions => ['title LIKE :title AND user_id = :user',
                                                  {:title => @post.title, :user => @session['user'].id }])
      flash[:notice] = "Your job request was posted successfully!"
      redirect_to :controller => 'post', :action => 'show', :id => @redirect_post.id
    else
      render :action => 'new'
    end
  end
  
  def create_IE
    @post = Post.new(params[:post])
    @post.user_id = @session['user'].id
    if @post.save
      # Checks all 3 picture upload slots. If a picture was uploaded it is CHMODed to 644 to 
      # allow all users read access
      if @post.pic_1.nil?
      else
      FileUtils.chmod 0644, @post.pic_1
      end
      if @post.pic_2.nil?
      else
      FileUtils.chmod 0644, @post.pic_2
      end
      if @post.pic_3.nil?
      else
      FileUtils.chmod 0644, @post.pic_3
      end
      # Determines which post was just created for a redirect after creation
      @redirect_post = Post.find(:first,
                                 :conditions => ['title LIKE :title',
                                                  {:title => @post.title}])
      flash[:notice] = "Your job request was posted successfully!"
      redirect_to :controller => 'post', :action => 'show', :id => @redirect_post.id
    else
      render :action => 'new_IE'
    end
  end

  # Action for "delete" initiated from the bidder
  def bidder_pre_destroy
    @post = Post.find(params[:id])
      # Determines if the bidder is actually the winner of the post and that the
      # poster has not yet "deleted"
      if @post.winner == @session['user'].id and @post.delete_id == 0
        @post.update_attribute("bidder_delete_id", @session['user'].id)
        redirect_to :controller => 'account', :action => 'your_bids_ajax'
      # If above if statement fails (the poster has "deleted") the post is actually
      # deleted from the DB
      else
          if @post.winner == @session['user'].id
            Bid.destroy_all "post_id = #{@post.id}"
            @post.destroy
            redirect_to :controller => 'account', :action => 'your_bids_ajax'
          end
      end
  end
  
  def pre_destroy
    @post = Post.find(params[:id])
      # Determines if the poster is actually the owner of the post and that the
      # bidder has not yet "deleted"
      if @post.user_id == @session['user'].id and @post.bidder_delete_id == 0
        @post.update_attribute("delete_id", @session['user'].id)
        redirect_to :controller => 'account', :action => 'your_posts_ajax'
      # If above if statement fails (the bidder has "deleted") the post is actually
      # deleted from the DB
      else
        if @post.user_id == @session['user'].id
          Bid.destroy_all "post_id = #{@post.id}"
          @post.destroy
          redirect_to :controller => 'account', :action => 'your_posts_ajax'
        end
      end
  end
  
  # Place holder for possible future search page code
  def search
  end

  # Displays search results
  def show_search
      @query = params[:query]
      # Grabs untouched search string for complete display
      @search_string = @query
    unless @query.nil?
      # Splits search string into individual words
      @queries = @query.split(' ')
      # Find call for each word in the @queries array. Loops until all words have been 
      # processed. Paginated.
      @queries.each {|@query|
      @post_pages, @posts = paginate(:post, 
                         :conditions => [ '(title LIKE :search_query OR body LIKE :search_query OR city LIKE :search_query OR state LIKE :search_query) AND end_date >= :enddate',
                                          {:search_query => '%' + @query.to_s + '%', :enddate => Time.now}],
                         :order => 'end_date',
                         :per_page => 20)}
      # Loops to create a seperate array of all results (non-paginated) to be used for a total 
      # number of results display
      @queries.each {|@query|
      @result_num = Post.find(:all, 
                              :conditions => [ '(title LIKE :search_query OR body LIKE :search_query OR city LIKE :search_query OR state LIKE :search_query) AND end_date >= :enddate',
                                               {:search_query => '%' + @query.to_s + '%', :enddate => Time.now}],
                              :order => 'end_date')}
    end
  end
  
  # Shows lowest 4 bids for given post when user is able to accept a bid
  def accept
    @post = Post.find(params[:post])
    @bids = Bid.find(:all,
                       :conditions => [ 'post_id = :pid',
                                         {:pid => @post.id}],
                       :order => 'amount',
                       :limit => 4)
  end
  
  #Shows all bids for given post when user is able to accept a bid
  def accept_all
    @post = Post.find(params[:post])
    @bids_all = Bid.find(:all,
                         :conditions => [ 'post_id = :pid',
                                           {:pid => @post.id}],
                         :order => 'amount')
  end
  
  #Writes "winner" and "winning_bid" to posts table for the given post
  def accepted
    @bidder = User.find(params[:id])
    @post = Post.find(params[:post])
    @post.update_attribute("winner", params[:id])
    @post.update_attribute("winning_bid", params[:amount])
    # Emails the winning bidder
    Notifier::deliver_been_accepted( @bidder )
      flash[:notice] = "The winner has been emailed, and should be contacting you shortly!"
      redirect_to :controller => 'account', :action => 'welcome'
  end
  
  # Determines the total active posts in the DB for display in AJAX header module
  def total_active_posts
    @total_active_posts = Post.find(:all,  
                                    :conditions => 'end_date >= NOW()')
    render(:layout => false)
  end
  
  # Preps data for display on post/browse
  def browse
    # Finds all tags and their values in the Tags table
    @tags = Tag.find(:all,
                     :conditions => 'num > 0',
                     :order => 'name')
    # Tallies up the total value of all tags for percentage calculation in view
    @tags.each{|@tag|@tag_total = @tag_total.to_i + @tag.num }
  end

end
