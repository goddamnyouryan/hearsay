class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    content_type "text/html"
    @subject = 'Activate your new account.'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    content_type "text/html"
    @subject = 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def reset_notification(user)
    setup_email(user)
    content_type "text/html"
    @subject = 'Reset your password.'
    @body[:url]  = "http://www.mysite.com/reset/#{user.reset_code}"
  end
  
  def invitation(user, inviter)
  	content_type "text/html"
  	@recipients = "#{user}"
    @from = "HEARSAY <donotreply@thisishearsay.com>"
    @subject = "You've been invited to HEARSAY.  You must be special."
    @sent_on = Time.now
    @user = inviter.name
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = "HEARSAY <donotreply@thisishearsay.com>"
    @sent_on = Time.now
    @body[:user] = user
  end
end
