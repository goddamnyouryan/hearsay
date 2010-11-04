class VotesController < ApplicationController

 def create
 	if logged_in?
  	@answer = Answer.find(params[:answer_id])
  	@answer.votes.create(:user_id => current_user.id)
  	respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
  else
  	redirect_to login_path, :return_to => request.request_uri
  end
 end

	def destroy
		@answer = Vote.find_by_answer_id(params[:answer_id])
		@vote = Vote.find_by_user_id(current_user.id)
		@vote.destroy
		respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
	end

end
