class StoryPolicy < ApplicationPolicy
  def index?
    if @user.blank?
      false
    else
      @user.admin?
    end
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def edit?
    index?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

end
