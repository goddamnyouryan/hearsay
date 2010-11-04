class Comment < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :answer
	validates_presence_of :answer_id, :message, :user_id
	
	acts_as_state_machine :initial => :unread, :column => :state

   state :unread
   state :read

   event :view do
     transitions :to => :read, :from => :unread
   end

	
end
