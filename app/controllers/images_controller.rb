class ImagesController < ApplicationController
	before_filter :login_required
	after_filter :mark_unread_images_as_read, :only => :index
	
  def index
  	@user = User.find(params[:user_id])
  	if current_user.friends.include?(@user) || @user == current_user
  		@image = @user.images
  	else
  		redirect_to home_path
  	end
  end
  
  def create
  	@user = User.find(params[:user_id])
  	@image = Image.create(params[:image])
  	
  	event = @user.events.create
		event.kind = "photo"
		event.data = { "image" => "#{@image.id}", "uploader" => "#{current_user.login}" }
		event.save!
			
		redirect_to user_images_path(@user)
	end
	
	def show
		@image = Image.find(params[:id])
		@author = User.find(@image.friend_id)
		@user = User.find(@image.user_id)
		@images = @user.images
		previous_image = @images.index(@image) - 1
		@previous = @images[previous_image]
		next_image = @images.index(@image) + 1
		if @images.index(@image) == @images.index(@images.last)
			@next = @images.first
		else
			@next = @images[next_image]	
		end
	end
	
	def initial_image
		@user = current_user
		if params[:image]
			@image = Image.create(params[:image])
			if @image.save
				@image.view!
				event = @user.events.create
				event.kind = "photo"
				event.data = { "image" => "#{@image.id}", "uploader" => "#{current_user.login}" }
				event.save!
				redirect_to :controller => 'profile', :action => 'index'
			end
		end
	end
	
	
	private
	
	  def mark_unread_images_as_read
	  	if @user == current_user
	  		@user.images.each do |state|
	  			if state.state == "unread"
	  				state.view!
	  			end
	  		end
	  	end
  	end

end
