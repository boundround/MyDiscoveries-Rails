class UcgUpdate < ActionMailer::Base
  default to: "natasha@boundround.com", "janeece@boundround.com"
          from: "website@BoundRound.com"

  def send_update
    time = Time.now.strftime("%d/%m/%y")
    @photos = UserPhoto.where(["created_at > ?", 7.days.ago])
    @stories = Story.where(["created_at > ?", 7.days.ago])
    @reviews = Review.where(["created_at > ?", 7.days.ago])
    mail(subject: "Weekly UCG Update - #{time}")
  end
end
