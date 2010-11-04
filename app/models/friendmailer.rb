class Friendmailer < ActionMailer::Base

  def friend_notification(user, friend)
    setup_email(user)
    content_type "text/html"
    @subject = "#{friend} wants to be friends"
    @body[:url]  = "http://#{SITE_URL}"
    @friend = friend
    @user = user.login
  end  
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = "HEARSAY <donotreply@thisishearsay.com>"
    @sent_on = Time.now
    @body[:user] = user
  end

end
