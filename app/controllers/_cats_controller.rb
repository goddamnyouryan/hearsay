class CatsController < ApplicationController
		
	def create
		cat = current_user.cats.create(params[:cat])
		cat.save!
		event = cat.user.events.create
		event.kind = "cat"
		event.data = { "message" => "#{cat.message}" }
		event.save!
		redirect_to root_path
	end
	
	
	def destroy
		@cat = Cat.find(params[:id])
		@cat.destroy
		redirect_to home_path
	end
	
	def show
		@cat = Cat.find(params[:id])
		cat = Cat.find(params[:id])
		@user = User.find(cat[:user_id])
		answers = cat.answers
	end
	
  def fuck
  	@answer = Answer.find(params[:answer])
		render :update do |page| 
     page.insert_html :bottom, "comment_list_#{@answer.id}", :partial => 'comments/comment', :collection => @answer.comments
     page.replace_html "comments_view_toggle_#{@answer.id}", :partial => 'hide', :locals => { :answer => @answer }
     page.insert_html :bottom, "new_comment_form_#{@answer.id}", :partial => 'comments/new_comment_form', :locals => { :answer => @answer }
    end 
  end
  
  def explode
  	@answer = Answer.find(params[:answer])
		render :update do |page| 
     page.replace_html "comment_list_#{@answer.id}", "&nbsp;"
     page.replace_html "new_comment_form_#{@answer.id}", "&nbsp;"
     page.replace_html "comments_view_toggle_#{@answer.id}", :partial => 'reveal', :locals => { :answer => @answer }
    end 
  end
	
end
