class EventsController < ApplicationController
  def index
  	@user = User.find(params[:user_id])
  	@user_stream = @user.profile_stream
  end

end
