class PostPolicy < ApplicationPolicy

  def index?
    if @user.blank?
      false
    else
      (@user.admin? || @user.roles.map(&:name).include?('contributor'))
    end
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

end