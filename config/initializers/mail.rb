ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address => "smtp.sendgrid.net",
	:port => 25,
	:domain => "thisishearsay.com",
	:authentication => :plain,
	:user_name => "ryan.macinnes@gmail.com",
	:password => "garbage",
	:enable_starttls_auto => false
}
