class CountryPolicy < ApplicationPolicy

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