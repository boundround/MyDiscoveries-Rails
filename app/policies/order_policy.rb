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

  def abandoned?
    user.admin?
  end

  def resend_confirmation?
    user.admin?
  end

  def index?
    user.admin?
  end

  def add?
    new?
  end

  def view_confirmation?
    user.admin?
  end

  def edit_confirmation?
    user.admin?
  end

  def update_customer?
    user.admin?
  end

  def customer_info?
    user.admin?
  end

  def edit_line_items?
    user.admin?
  end

  def update_departure_date?
    user.admin?
  end
end
