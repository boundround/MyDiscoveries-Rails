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

  def download_pdf?
    new?
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
