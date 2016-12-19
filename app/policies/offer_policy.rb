class OfferPolicy < ApplicationPolicy

  def index?
    if @user.blank?
      false
    else
      (@user.admin? || @user.has_role?('publisher'))
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

  def new_livn_offer?
    index?
  end

  def create_livn_offer?
    index?
  end

  def show?
    true
  end
end