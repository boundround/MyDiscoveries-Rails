class Share < ActionMailer::Base
  # default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.share.postcard.subject
  #
  def postcard(name, email, message, photo, place, area, country)
    @name = name
    @email = email
    @message = message
    @photo = photo
    @place = place
    @area = area
    @country = country

    mail from: name, to: email
  end
end
