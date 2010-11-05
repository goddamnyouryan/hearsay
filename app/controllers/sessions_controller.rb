class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
  	if logged_in?
  		if params[:return_to]
  			return_path = params[:return_to]
  			redirect_to return_path
  		else
  			redirect_to home_path
  		end
  	end
  	@subtitle = ['an evolutionary new kind of social network.', 'not your parents social network.', 'the bastard child of facebook and wikipedia.', 'what do your friends really think of you?', 'facebook + wikipedia - creepers + honesty']
  	@splash_cats = Cat.find(:all, :conditions => ["state in (?)", "public"], :order => 'created_at DESC', :limit => 10)
  end

  def create
    logout_keeping_session!
    password_authentication
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(root_path)
  end
  
  def terms
  end
  

  protected
  
  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login = params[:login]
      @remember_me = params[:remember_me]
      redirect_back_or_default(home_path)
    end
  end
  
  def successful_login
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    if params[:return_to]
    	redirect_to params[:return_to]
    else
	    redirect_back_or_default(home_path)
	    flash[:notice] = "Logged in successfully"
 	  end
  end

  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
