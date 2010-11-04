class ProfileController < ApplicationController
	
	def index
		redirect_to '/profile'
	end

  def edit
  	@user = current_user
  	@user.profile ||= Profile.new
  	@profile = @user.profile
  	@goddamnyouryan = User.find_by_login("goddamnyouryan")
  	@admin_emails = User.find(:all)
  	if param_posted?(:profile)
  		if @user.profile.update_attributes(params[:profile])
  			flash[:notice] = 'Changes to profile saved.'
  			redirect_to find_friends_path
  		end
  	end
  end

end
