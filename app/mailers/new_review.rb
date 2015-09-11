class NewReview < ActionMailer::Base
  default from: "website@BoundRound.com"

  def notification(review)
    @email = "janeece@boundround.com"
    @review = review

    mail(to: @email, subject: "New Review Created - #{@review.reviewable.display_name}, #{@review.reviewable.country.display_name}")
  end
end
