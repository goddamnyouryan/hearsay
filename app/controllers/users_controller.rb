class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  after_filter :mark_unread_friendships_as_read, :only => :show
  
  def index
  	@user = User.search(params[:search])
  end
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    create_new_user(params[:user])
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  def find_friends
		#@user = User.find(params[:id])
	end

	def import
		@users = User.find(current_user)
		begin
			@sites = {"gmail"  => Contacts::Gmail, "yahoo" => Contacts::Yahoo, "hotmail" => Contacts::Hotmail}
			@contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts
			@users = User.find_all_by_email(@contacts.collect{|contact| contact[1]})
		end
	end
	
	def invite
		@user = current_user
		params[:email_ids].each do |f|
			UserMailer.deliver_invitation(f, @user)
		end
		flash[:notice] = "Invitation emails sent!"
		redirect_to suggestions_path
	end
	
  
  # From the old build of hearsay
  
  def show
  	if !logged_in?
  		redirect_to :controller => :sessions, :action => :new, :return_to => request.request_uri
  	else
	  	login = params[:login]
	  	@user = User.find_by_login(login)
	  	@user_stream = @user.profile_stream_short
	  	@user.images.highest_ranked.each do |i|
	  		@image = i.photo.url(:profile)
			end			  	
	  	@cats = @user.cats.paginate :page => params[:page], :order => "created_at desc", :per_page => 30
	  	@user.profile ||= Profile.new
	  	@profile = @user.profile
  	end
  end
  
  protected
  
  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      @user.register!
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = "An activation email has been sent to your provided email address. Check it!"
  end
  
  def failed_creation(message = 'Sorry, there was an error creating your account')
    flash[:error] = message
    render :action => :new
  end
  
  private
  
  def mark_unread_friendships_as_read
  	if current_user.friends.include?(@user)
  		@friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, @user.id)
			@friendship.view!
  	end
  end
  
end
