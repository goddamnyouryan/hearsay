class Rank < ActiveRecord::Base
	belongs_to :user
	belongs_to :image, :counter_cache => true
end
