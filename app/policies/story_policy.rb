class StoryPolicy < ApplicationPolicy

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
  
  def edit?
    user.id == record.user_id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

end