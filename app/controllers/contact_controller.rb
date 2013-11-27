class ContactController < ApplicationController

  # Submits message, category, etc. to the "contacts" table in the DB. To be read only by us
  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:notice] = "Thank you for submitting your comment. We will contact you as soon as possible"
      redirect_to :controller => 'main', :action => 'welcome'
    else
      render :action => 'send'
    end
  end

end
