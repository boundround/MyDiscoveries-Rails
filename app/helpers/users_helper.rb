module UsersHelper
  def list_moderator_place(role)
    if role.resource_id
      if role.resource_type == "Place"
        Place.find(role.resource_id).display_name
      elsif role.resource_type == "Area"
        Area.find(role.resource_id).display_name
      else
        ""
      end
    else
      ""
    end
  end

  def getRatingByReview(user_id, reviewable_id)
    Rate.where(rater_id: user_id).where(rateable_id: reviewable_id)
  end
end
