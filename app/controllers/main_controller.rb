class MainController < ApplicationController
  
  def welcome
    
  end
  
  def video_signup
    render(:layout => false)
  end
  
  def video_signup_send
    user = @session['user']
    @video = Video.new(params[:video])
      @video.user_id = user.id
    if @video.save
      flash[:notice] = "Thanks for your entry. Good luck!"
      redirect_to :controller => "main", :action => "welcome"
    else
      flash[:notice] = "Something went horribly wrong! Remember, you can only submit each video once."
      redirect_to :action => "video_contest"
    end
  end
  
  # Generates RSS feed containing all posts that have not expired
  def rss
    @posts = Post.find(:all,
                       :conditions => ['end_date >= :enddate',
                          {:enddate => Time.now}])
    render_without_layout
  end
  
  # Generates RSS based on a custom query
  def custom_rss
    @query = params[:query]
    @queries = @query.split(' ')
      @queries.each {|@query|
      @posts = Post.find(:all, 
                         :conditions => [ '(title LIKE :search_query OR body LIKE :search_query OR city LIKE :search_query OR state LIKE :search_query) AND end_date >= :enddate',
                                          {:search_query => '%' + @query.to_s + '%', :enddate => Time.now}],
                         :order => 'end_date')}
    render_without_layout
  end
  
end
