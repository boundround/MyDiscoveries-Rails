class NewUserPhoto < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(photo)
    @email = "janeece@boundround.com"
    @photo = photo
    if @photo.place
      @place = @photo.place
    else
      @place = @photo.area
    end

    mail(to: @email, subject: "New User Photo Uploaded - #{@place.display_name}, #{@place.country.display_name}")
  end
end
