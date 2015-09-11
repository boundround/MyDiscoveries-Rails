class NewStory < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(story)
    @email = "janeece@boundround.com"
    @story = story

    mail(to: @email, subject: "New Story Created - #{@story.storiable.display_name}, #{@story.storiable.country.display_name}")
  end
end
