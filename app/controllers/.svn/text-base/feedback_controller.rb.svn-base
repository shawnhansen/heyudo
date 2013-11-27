class FeedbackController < ApplicationController

  # Gathers data to be displayed in initial "give feedback" display
  def give_feedback
    @user = User.find(params[:id])
      @post = Post.find(params[:post])
      @feedback = Feedback.new
      render(:layout => false)
  end

  # Actual processing of submitted feedback
  def sent
    @post = Post.find(params[:post])
    @user = User.find(params[:user])
    @feedback = Feedback.new(params[:feedback])
    @feedback.user_id = @session['user'].id
    @feedback.bidder_id = @user.id
    @feedback.post_id = @post.id
    if @feedback.save
      # If "thumbs up" was given with feedback. The bidders "reputation" has 10 added to it.
      # Then updates "left_feedback" to 1 for the current post
      if @post.user_id == @session['user'].id and @post.left_feedback == 0 and @feedback.rated == 2
        @user.update_attribute("reputation_points", @user.reputation_points + 10)
        @post.update_attribute("left_feedback", 1)
      end
      # If "thumbs down" was given with feedback. The bidders "reputation" has 10 subtracted from it.
      # Then updates "left_feedback" to 1 for the current post
      if @post.user_id == @session['user'].id and @post.left_feedback == 0 and @feedback.rated == 1
         @user.update_attribute("reputation_points", @user.reputation_points - 10)
         @post.update_attribute("left_feedback", 1)
      end
          flash[:notice] = "Your feedback was sent successfully!"
          redirect_to :controller => 'account', :action => 'welcome', :id => @post.id
    else
          flash[:notice] = "Your feedback did not send properly. Please try again. Remember comments must be between 5 and 80 characters and you must give a Thumbs up or Thumbs down rating"
          render :action => 'give_feedback'
    end
  end

  end
