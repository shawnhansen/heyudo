class BillingController < ApplicationController

  before_filter :logged_in

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    redirect_to :controller => 'account', :action => 'welcome'
    #@bill_pages, @bills = paginate :bills, :per_page => 10
  end

  def show
    redirect_to :controller => 'account', :action => 'welcome'
    #@bill = Bill.find(params[:id])
  end

  def new
    @bill = Bill.new
  end

  def create
      @bill = Bill.new(params[:bill])
      #Pulls user's id from session to be save under "user_id"
      @bill.user_id = @session['user'].id
      #Pulls user's id from session then writes a "1" to the "users" table for that id
      @user = User.find(@session['user'].id)
      @user.update_attribute("has_billing", "1")
    if @bill.save
      flash[:notice] = 'Your billing information was successfully saved!'
      redirect_to :controller => 'account', :action => 'welcome'
    else
      render :action => 'new'
    end
  end

  def edit
    redirect_to :controller => 'account', :action => 'welcome'
    #@bill = Bill.find(params[:id])
  end

  def update
    @bill = Bill.find(params[:id])
    if @bill.update_attributes(params[:bill])
      flash[:notice] = 'Bill was successfully updated.'
      redirect_to :action => 'show', :id => @bill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Bill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
