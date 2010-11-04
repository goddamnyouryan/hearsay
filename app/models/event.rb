class Event < ActiveRecord::Base
	serialize :data
	
	belongs_to :user
	
	VALID_TYPES = ["cat", "answer", "comment", "top_response", "friend", "photo"]
	
	validates_inclusion_of :kind,
												 :in => VALID_TYPES,
												 :allow_nil => false
end
