class NewPlace < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(place)
    @email = "donovan.whitworth@gmail.com"
    @place = place

    mail(to: @email, subject: "New Place Created - #{@place.display_name}, #{@place.country.display_name}")
  end
end
