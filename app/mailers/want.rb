class Want < ActionMailer::Base
  default from: "website@boundround.com"

  def notification(place, address)
    @email = "janeece@boundround.com"
    @place = place
    @address = address

    mail(to: @email, subject: "Someone has requested #{@place} in Bound Round")
  end
end
