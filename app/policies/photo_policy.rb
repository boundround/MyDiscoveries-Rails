class PhotoPolicy < ApplicationPolicy
  def choose_hero?
    if @user.blank?
      false
    else
      @user.admin?
    end
  end
end
