class OfferPolicy < ApplicationPolicy

  def index?
    true
  end

  def cms_index?
    if @user.blank?
      false
    else
      (@user.admin? || @user.has_role?('publisher'))
    end
  end

  def choose_hero?
    cms_index?
  end

  def update_hero?
    cms_index?
  end

  def create?
    cms_index?
  end

  def new?
    cms_index?
  end

  def update?
    cms_index?
  end

  def edit?
    cms_index?
  end

  def destroy?
    cms_index?
  end

  def all_offers?
    true
  end

  def new_livn_offer?
    cms_index?
  end

  def create_livn_offer?
    cms_index?
  end

  def show?
    true
  end
end
