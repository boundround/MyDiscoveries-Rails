class ProductsStoryPolicy < ApplicationPolicy
  def index?
    return false if @user.blank?
    @user.admin || @user.has_role?(:editor)
  end

  def create?
    index?
  end

  def destroy?
    index?
  end
end
