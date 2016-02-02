class UcgUpdate < ActionMailer::Base
  default from: "website@BoundRound.com"

  def send_update
    @email = "donovan@boundround.com"
    time = Time.now.strftime("%d/%m/%y")
    @photos = UserPhoto.where(["created_at > ?", 7.days.ago])
    @stories = Story.where(["created_at > ?", 7.days.ago])
    @reviews = Review.where(["created_at > ?", 7.days.ago])
    mail(to: @email, subject: "Weekly UCG Update - #{time}")
  end
end
