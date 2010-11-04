class HomeController < ApplicationController
	before_filter :login_required
	
	def index
		@user = current_user
		if @user.images.empty? && @user.profile.nil? && @user.friends.empty?
			redirect_to initial_image_path
		end
		@user.profile ||= Profile.new
  	@profile = @user.profile
  	@user_stream = @user.stream.paginate :page => params[:page], :order => "created_at desc"
  	@user.images.highest_ranked.each do |i|
  		@image = i.photo.url(:profile)
		end
  	
  	friend_notifications = 0
  	@user.friendships.each do |f|
	  		if f.state == "unread"
	  			friend_notifications = 1 + friend_notifications
	  		end
  	end
  	@friend_notifications = friend_notifications
  	
  	friend_request_notifications = 0
  	unless current_user.pending_friends.empty?		
  		current_user.pending_friends.each do |r|
	  		friend_request_notifications = 1 + friend_request_notifications
	  	end
  	end
  	@friend_request_notifications = friend_request_notifications
  	
  	answer_notifications = 0
  	@user.cats.each do |c|
  		c.answers.each do |n|
	  		if n.state == "unread"
	  			answer_notifications = 1 + answer_notifications
	  		end
	  	end
  	end
  	@answer_notifications = answer_notifications
  	
  	comment_notifications = 0
  	@user.answers.each do |n|
  		n.comments.each do |c|
	  		if c.state == "unread"
	  			comment_notifications = 1 + comment_notifications
	  		end
	  	end
  	end
  	@comment_notifications = comment_notifications
  	
  	image_notifications = 0
  	@user.images.each do |i|
	  	if i.state == "unread"
	  			image_notifications = 1 + image_notifications
	  	end
  	end
  	@image_notifications = image_notifications
  	
  	@notifications = 	friend_notifications + friend_request_notifications + answer_notifications + comment_notifications + image_notifications
  	
	end
	
	def public_stream
		@public_stream = current_user.public_categories.paginate :page => params[:public], :order => "created_at desc"
		render :update do |page|
			if @public_stream.current_page == 1 
	      page.replace_html "stream", :partial => "public_stream"
	      page.replace_html "stream_toggle", :partial => "friends_stream"
	      page.replace "more_stream", :partial => "public_pagination"
    	else
	      page.insert_html :bottom, :stream, :partial => 'public_stream'
				if @public_stream.current_page >= @public_stream.total_pages
					page[:more_stream_fuck].hide
				end
			end
      
    end 
	end
	
	def friends_stream
		@user_stream = current_user.stream.paginate :page => params[:page], :order => "created_at desc"
		render :update do |page| 
			if @user_stream.current_page == 1
	      page.replace_html "stream", :partial => "stream"
	      page.replace_html "stream_toggle", :partial => "public_toggle"
	      page.replace "more_stream_fuck", :partial => "friends_pagination"
    	else
    		page.insert_html :bottom, :stream, :partial => 'stream'
				if @user_stream.current_page >= @user_stream.total_pages
					page[:more_stream].hide
				end
			end
    		
    end 
  end
		
end
