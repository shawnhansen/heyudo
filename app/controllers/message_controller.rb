class MessageController < ApplicationController

  before_filter :logged_in, :except => [:send_message]
  
  # Finds info to prep for message to be sent
  def send_message
    # Checks the "confirmed" field for logged in user. If not confirmed (0), the user
    # is redirected to the confirmation page (/account/confirmation/rhtml)
  unless @session['user'].nil?
    if @session['user'].confirmed == 0
      redirect_to :controller => 'account', :action => 'confirmation'
    end
  end
    @receiver = User.find(params[:receiver])
    @post = Post.find(params[:post])
    @message = Message.new
    render(:layout => false)
  end

  # Records message from form to the database, then displays a confirmation
  def sent_message
    @post = Post.find(params[:post])
    @receiver = User.find(params[:receiver])
    @message = Message.new(params[:message])
    @message.sender_id = @session['user'].id
    @message.receiver_id = @receiver.id
    @message.post_id = @post.id
      if @message.save
        # Sends email to receiver of message, then redirects back to refering post
        Notifier::deliver_new_message( @receiver )
        flash[:notice] = "Your message was sent successfully!"
        redirect_to :controller => 'post', :action => 'show', :id => @post.id
      else
        flash[:notice] = "Your message did not send properly. Please try again"
        render :action => 'send_message'
      end
  end
  
  # Stores specified message and updates is_read to 1 for read/unread function
  def show
    @message = Message.find(params[:id])
    @message.update_attribute("is_read", 1)
    render(:layout => false)
  end
  
  # Preps info for reply to message
  def reply
    @message = Message.find(params[:message])
    @post = Post.find(params[:post])
    render(:layout => false)
  end
  
  #Takes reply from form and constructs a new message switching the send and receiver id's
  #also automatically supplies a subject line appending "RE:" to the beginning of the
  #already existing message subject
  def sent_reply
    @reply = Message.find(params[:reply])
    @message = Message.new(params[:message])
    @message.sender_id = @session['user'].id
    @message.receiver_id = @reply.sender_id
    @message.post_id = @reply.post_id
    @message.subject = ("RE:" + @reply.subject )
    @receiver = User.find(@message.receiver_id)
      if @message.save
        # Sends email to receiver of message, then redirects back to refering post
        Notifier::deliver_new_reply( @receiver )
        flash[:notice] = "Your message was sent successfully!"
        redirect_to :controller => 'account', :action => 'welcome'
      else
        flash[:notice] = "Your message did not send properly. Please try again"
        render :action => 'reply'
      end
  end
  
  #Delete function for messages
  def destroy
    @message = Message.find(params[:id])
    # Checks to see if user actually owns the message tey're deleting
    if @message.receiver_id == @session['user'].id
      @message.destroy
      redirect_to :controller => 'account', :action => 'inbox_ajax'
    else
      redirect_to :controller => 'account', :action => 'inbox_ajax'
    end
  end

end
