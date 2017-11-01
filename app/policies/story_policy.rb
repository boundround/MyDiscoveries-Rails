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

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

  def seo_analysis?
    index?
  end
end
