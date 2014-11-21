class Want < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(place, city, country)
    @email = "Janeece@BoundRound.com"
    @place = place
    @city = city
    @country = country

    mail(to: @email, subject: 'Someone wants a place in Bound Round')
  end
end
