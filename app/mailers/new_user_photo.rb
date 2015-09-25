class NewUserPhoto < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(photo)
    @email = "janeece@boundround.com"
    @photo = photo
    if @photo.place
      @place = @photo.place
    elsif @photo.area
      @place = @photo.area
    end

    mail(to: @email, subject: "New User Photo Uploaded - #{@place ? @place.display_name : 'Needs Place Assignment'}")
  end
end
