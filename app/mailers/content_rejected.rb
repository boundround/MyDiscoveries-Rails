class ContentRejected < ActionMailer::Base
  default from: "cms@boundround.com"

  def send_rejected(place_id, asset_type, asset_id, email, comments)
    @place = Place.find(place_id)
    @asset_id = asset_id.to_s
    @asset_type = asset_type
    @email = email
    @comments = comments

    mail(to: "donovan@boundround.com",
        subject: "Content Rejected: " + @place.display_name + ": " + @asset_type + " " + @asset_id
        )
  end
end
