class AnswersController < ApplicationController
	before_filter :login_required
	
	def create
		cat = Cat.find(params[:cat_id])
		answer = cat.answers.create(params[:answer])
		answer.user = current_user
		answer.save!
		if answer.cat.user == current_user
			answer.view!
		end
		event = answer.user.events.create
		event.kind = "answer"
		event.data = { "message" => "#{answer.message}", "category" => "#{cat.message}", "cat_user" => "#{cat.user.login}" }
		event.save!
		unless answer.cat.user == current_user
			AnswerMailer.deliver_new_answer(answer.cat.user, answer.user, answer.message)
		end
		answer.event_id = event.id
		answer.save!
		render :update do |page|
  		page.insert_html :bottom, "response_list", :partial => 'answers/new_answer', :locals => { :answer => answer }
  		page["answer_message"].clear
  	end
	end
	
	def destroy
		@answer = Answer.find(params[:poop])
		@event = Event.find(@answer.event_id)
		@answer.destroy
		@event.destroy
		respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
	end
		
end
