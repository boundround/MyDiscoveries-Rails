class UserPolicy < ApplicationPolicy

  def index?
    if @user.blank?
      false
    else
      (@user.admin? || !@user.blank?)
    end
  end

  def show?
    index?
  end

end