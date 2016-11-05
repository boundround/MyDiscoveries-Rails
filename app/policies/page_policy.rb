class PagePolicy < ApplicationPolicy

  def create?
    if @user.blank?
      false
    else
      (@user.admin? || @user.has_role?('contributor'))
    end
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def all_pages?
    create?
  end

end