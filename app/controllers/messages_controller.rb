class MessagesController < ApplicationController
  def index
  end

  def show
  end

  def create
  	@user = User.find(params[:recepient])
  end

end
