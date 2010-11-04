class RanksController < ApplicationController
 
	 def create
  	@image = Image.find(params[:image_id])
  	@image.ranks.create(:user_id => current_user.id)
  	respond_to do |format|
  		format.html { redirect_to root_url }
  		format.js
  	end
  end

end
