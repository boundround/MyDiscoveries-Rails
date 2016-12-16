class OrderPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def edit?
    new?
  end

  def checkout?
    new?
  end
end
