class AnswerMailer < ActionMailer::Base
  
  def new_answer(user, responder, response)
    setup_email(user)
    content_type "text/html"
    @subject = "#{responder.login} responded to your category."
    @body[:url]  = "http://#{SITE_URL}"
    @responder = responder.login
    @response = response
  end 

  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = "HEARSAY <donotreply@thisishearsay.com>"
    @sent_on = Time.now
    @body[:user] = user
  end

end
