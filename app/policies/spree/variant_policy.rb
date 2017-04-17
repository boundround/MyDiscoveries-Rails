class Spree::VariantPolicy < ApplicationPolicy

  def index?
    if @user.admin? || @user.has_role?('publisher')
      true
    else
      false
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

  def show?
    true
  end

  def fill_packages_options?
    true
  end
end
