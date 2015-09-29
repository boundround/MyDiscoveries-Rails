class LiveNotification < ActionMailer::Base
  default from: "website@boundround.com"

  def photo_notification(photo)

    @photo = photo
    @user = photo.user

    mail(to: @user.email, subject: "Your photo on Bound Round is now publicly viewable")
  end

  def story_notification(story)
    @story = story
    @user = story.user

    mail(to: @user.email, subject: "Your story on Bound Round is now publicly viewable")
  end

  def review_notification(review)
    @review = review
    @user = review.user

    mail(to: @user.email, subject: "Your review on Bound Round is now publicly viewable")
  end
end
