require 'paperclip'

class Image < ActiveRecord::Base
	
	belongs_to :user
	has_many :ranks
	has_attached_file :photo, :styles => {  :full =>"800x800>",
																					:images => "250x250#", 
																					:profile => "90x90#", 
																					:cat => "60x60#", 
																					:small => "30x30#"
																					}, 
														:storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ':id/:style'
														
	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	
	acts_as_state_machine :initial => :unread, :column => :state

  state :unread
  state :read

  event :view do
  	transitions :to => :read, :from => :unread
  end
	
end
