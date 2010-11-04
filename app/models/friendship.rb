class Friendship < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :friend, :class_name => 'User', :foreign_key =>'friend_id'
	
	acts_as_state_machine :initial => :new, :column => :state
	
	 state :new
   state :unread
   state :read
   
   event :accept do
     transitions :to => :unread, :from => :new
   end

   event :view do
     transitions :to => :read, :from => :unread
   end
	
end
