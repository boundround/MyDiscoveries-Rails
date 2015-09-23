class NewReview < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(review)
    @email = "janeece@boundround.com"
    @review = review

    mail(to: @email, subject: "New Review Created - #{@review.reviewable ? @review.reviewable.display_name : 'Needs Place Assignment'}")
  end
end
