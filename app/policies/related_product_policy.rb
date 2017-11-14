class Spree::RelatedProductPolicy < ApplicationPolicy
  def index?
    if @user.blank?
      false
    else
      @user.admin?
    end
  end
end
