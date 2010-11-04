class Vote < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :answer, :counter_cache => true
	belongs_to :image, :counter_cache => true
	
end
