require 'digest/sha1'

class User < ActiveRecord::Base
	
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  # Validations
  validates_presence_of :login
  validates_length_of :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false
  validates_format_of :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email
  validates_length_of :email, :within => 6..100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  
  # Relationships
  has_and_belongs_to_many :roles
  has_many :cats, :dependent => :destroy
	has_many :answers, :dependent => :destroy
	has_many :cats_answered, :through => :answers, :source => :cat
	has_one :profile
	has_many :images
	has_many :votes
	has_many :messages
	has_many :comments
	has_many :events, :dependent => :destroy
	
	# Friendship
	has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
	has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => 'friendships.created_at'
	has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => 'friendships.created_at'
	has_many :friendships, :dependent => :destroy

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => ["email = ? OR login = ?",login,login]  # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  # Stuff from the old hearsay version
  
  has_many :images do
		def highest_ranked
			find :all, :order => 'ranks_count DESC', :limit => 1
		end
		
		def in_order_of_ranking
			find :all, :order => 'ranks_count DESC'
		end
	end
	
	def public_categories
		Cat.find(:all, :conditions => ["state in (?)", "public"], :order => "created_at desc")
	end
  	
	def user_public_categories
		Cat.find(:all, :conditions => ["user_id in (?) AND state in (?)", self.id, "public"])
	end
	
  def stream
  	Event.find(:all, :conditions => ["user_id in (?)", friends.map(&:id).push(self.id)], :order => "created_at desc")
  end
  
  def profile_stream_short
  	Event.find(:all, :conditions => ["user_id in (?)", self.id], :order => "created_at desc", :limit => 5 )
  end
  
  def profile_stream
  	Event.find(:all, :conditions => ["user_id in (?)", self.id], :order => "created_at desc" )
  end
  
  def self.search(search)
  	if search
  		find(:all, :conditions => ['LOWER(login) LIKE ? OR LOWER(name) LIKE ? OR LOWER(email) LIKE ? AND state LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "active"], :order => "login asc")
  	else
  		find(:all)
  	end
  end

  protected
    
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
end
