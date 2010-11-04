class Answer < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :cat
	has_many :votes
	has_many :comments
	validates_presence_of :cat_id, :message, :user_id
	
   acts_as_state_machine :initial => :unread, :column => :state

   state :unread
   state :read

   event :view do
     transitions :to => :read, :from => :unread
   end
  
	
end
