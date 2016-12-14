module UsersHelper
  def getRatingByReview(user_id, reviewable_id)
    Rate.where(rater_id: user_id).where(rateable_id: reviewable_id)
  end
end
