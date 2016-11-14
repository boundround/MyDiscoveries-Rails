class StoryPolicy < ApplicationPolicy
  def index?
    if @user.blank?
      false
    else
      (@user.admin? || @user.has_role?('contributor'))
    end
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def edit?
    debugger
    (@user.admin? || (@record.is_a?(ActiveRecord::Base) ? (@record.user_id == @user.id) : false))
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

end
