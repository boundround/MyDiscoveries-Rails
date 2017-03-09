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

  def cms_edit?
    user.admin?
  end

  def cms_update?
    user.admin?
  end

  def checkout?
    new?
  end

  def payment?
    new?
  end

  def confirmation?
    new?
  end

  def resend_confirmation?
    user.admin?
  end

  def add_passengers?
    new?
  end

  def update_passengers?
    new?
  end

  def edit_passengers?
    new?
  end
end
