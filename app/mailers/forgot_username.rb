class ForgotUsername < ActionMailer::Base
  default from: "website@BoundRound.com"

  def send_username(email, username)
    @email = email
    @username = username
    mail(to: @email, subject: 'Forgot Username')
  end
end
