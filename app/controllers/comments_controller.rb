class CommentsController < ApplicationController
  
  def create
		@answer = Answer.find(params[:answer])
		@comment = @answer.comments.create(params[:comment])
		@comment.user = current_user
		@comment.save!
		if @comment.answer.user == current_user
			@comment.view!
		end
		respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
  	
		event = @comment.user.events.create
		event.kind = "comment"
		event.data = { "message" => "#{@comment.message}", "answer" => "#{@comment.answer.message}", "answer_user" => "#{@comment.answer.user.login}" }
		event.save!
		
		@comment.event_id = event.id
		@comment.save!
  	
	end
	
	def destroy
		@answer = Answer.find(params[:cunt])
		@comment = Comment.find(params[:poop])
		@event = Event.find(@comment.event_id)
		@comment.destroy
		@event.destroy
		respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
	end

end
