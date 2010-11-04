class Profile < ActiveRecord::Base
	belongs_to :user
	
	VALID_GENDERS = ["Male", "Female"]
	START_YEAR = 1900
	VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
	
	validates_inclusion_of :gender,
												 :in => VALID_GENDERS,
												 :allow_nil => true,
												 :message => 'must be male or female'
												 
	validates_inclusion_of :birthday,
												 :in => VALID_DATES,
												 :allow_nil => true,
												 :message => 'is invalid!'
												 
end
