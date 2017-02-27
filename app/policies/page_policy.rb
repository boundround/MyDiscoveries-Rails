class PagePolicy < ApplicationPolicy

  def create?
    if @user.blank?
      false
    else
      @user.admin?
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
