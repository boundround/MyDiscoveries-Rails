class NewStory < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(story)
    @email = "janeece@boundround.com"
    @story = story

    mail(to: @email, subject: "New Story Created - #{@story.storiable ? @story.storiable.display_name : 'Needs Place Assignment'}")
  end
end
