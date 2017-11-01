class StoryPolicy < ApplicationPolicy
  def seo_analysis?
    if @user.blank?
      false
    else
      @user.admin?
    end
  end
end
