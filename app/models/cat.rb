class Cat < ActiveRecord::Base
	
	attr_accessor :private
	
	belongs_to :user
	has_many :answers, :dependent => :destroy
	validates_presence_of :user_id, :message
	
	
	def to_param
		"#{id}-#{message.gsub(/\W/, '-').downcase}"
	end
	

	has_many :answers do
		def highest_rated
			find :all, :order => 'votes_count DESC', :limit => 1
		end
		
		def in_order_of_rating
			find :all, :order => 'votes_count DESC'
		end
	end
	
	acts_as_state_machine :initial => :private, :column => :state

   state :private
   state :public

   event :make_public do
     transitions :to => :public, :from => :private
   end
   
   event :make_private do
     transitions :to => :private, :from => :public
   end

end
