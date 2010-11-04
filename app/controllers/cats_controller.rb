class CatsController < ApplicationController
	
	after_filter :mark_unread_messages_as_read, :only => :show
	after_filter :mark_unread_comments_as_read, :only => :fuck
		
	def create
		cat = current_user.cats.create(params[:cat])
		if cat.private == "1"
			cat.make_public! == "public"
		end
		cat.save!
		event = cat.user.events.create
		event.kind = "cat"
		event.data = { "message" => "#{cat.message}" }
		event.save!
		cat.event_id = event.id
		cat.save!
		@user_stream = current_user.stream.paginate :page => params[:page], :order => "created_at desc"
		render :update do |page|
			if cat.private == "1"
				page.insert_html :top, "stream", :partial => "home/new_cat_event", :locals => { :cat => cat }
			else
					page.replace_html "stream_toggle", :partial => "home/public_toggle"
					page.replace_html "stream", :partial => "home/stream"
					page.select('#more_stream_fuck').each do |element|
						element.replace "#{render :partial => "home/friends_pagination" }"
					end
	    end
			page["cat_message"].clear
		end
	end
	
	
	def destroy
		@cat = Cat.find(params[:id])
		@event = Event.find(@cat.event_id)
		@login = @cat.user.login
		@cat.destroy
		@event.destroy
		redirect_to :controller => 'users', :action => 'show', :login => @login
	end
	
	def show
		@cat = Cat.find(params[:id])
		cat = Cat.find(params[:id])
		@user = User.find(cat[:user_id])
		answers = cat.answers
		@user.images.highest_ranked.each do |i|
  		@image = i.photo.url(:cat)
		end

		@public_alt = "Public Categories are visible to everyone."
		@private_alt = "Private Categories are only visible to your friends."
		if cat.state =="private"
			unless @user.friends.include?(current_user) || @user == current_user
				redirect_to :controller => 'users', :action => 'show', :login => @user.login
				flash[:notice] = "This category is private. Add #{@user.login} as a friend to view."
			end
		end
	end
	
  def fuck
  	@answer = Answer.find(params[:answer])
		render :update do |page| 
     page.insert_html :bottom, "comment_list_#{@answer.id}", :partial => 'comments/comment', :collection => @answer.comments
     page.replace_html "comments_view_toggle_#{@answer.id}", :partial => 'hide', :locals => { :answer => @answer }
     page.insert_html :bottom, "new_comment_form_#{@answer.id}", :partial => 'comments/new_comment_form', :locals => { :answer => @answer }
    end
    @user = @answer.cat.user
  end
  
  def explode
  	@answer = Answer.find(params[:answer])
		render :update do |page| 
     page.replace_html "comment_list_#{@answer.id}", "&nbsp;"
     page.replace_html "new_comment_form_#{@answer.id}", ""
     page.replace_html "comments_view_toggle_#{@answer.id}", :partial => 'reveal', :locals => { :answer => @answer }
    end 
  end
  
  def make_public
  	@cat = Cat.find(params[:cat])
  	@cat.make_public!
  	@public_alt = "Public Categories are visible to everyone."
		@private_alt = "Private Categories are only visible to your friends."
  	render :update do |page|
  		page.replace_html "cat_toggle", :partial => 'make_private'
  	end
  end
  
  def make_private
  	@cat = Cat.find(params[:cat])
  	@cat.make_private!
  	@public_alt = "Public Categories are visible to everyone."
		@private_alt = "Private Categories are only visible to your friends."
  	render :update do |page|
  		page.replace_html "cat_toggle", :partial => 'make_public'
  	end
  end
  
  def suggestions
  	@suggestions = ["What would you say is my most annoying quality?", "How did we meet?", "What is my best feature, physically?", "What am I doing with my life?", "What does everyone else know about me that I don't know about myself?", "What's my favorite activity?", "What celebrity looks most like me?", "What's the most embarassing thing I've ever done?", "What do I need to do to better my life?"]
  end
  
  def create_suggestions
  	@user = current_user
		params[:suggestion_ids].each do |c|
			cat = current_user.cats.create
			cat.message = c
			cat.save!
		end
		flash[:notice] = "Categories created"
		redirect_to :controller => 'users', :action => 'show', :login => current_user.login
	end
  
  
  
  private
  
  def mark_unread_messages_as_read
  	if @user == current_user
  		@cat.answers.each do |state|
  			if state.state == "unread"
  				state.view!
  			end
  		end
  	end
  	end
	
  def mark_unread_comments_as_read
  	if @answer.user == current_user
  		@answer.comments.each do |c|
  			if c.state == "unread"
  				c.view!
  			end
  		end
  	end
  end
  			
  
	
end
