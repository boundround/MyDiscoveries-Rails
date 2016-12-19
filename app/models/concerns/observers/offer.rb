module Observers::Offer
  extend ActiveSupport::Concern

  included do
    after_commit :create_shopify_product, on: :create
    # after_commit :update_shopify_product, on: :update
  end

  private

  def create_shopify_product
    Offer::Shopify::ProductCreator.perform_async(id)
  end

  def update_shopify_product
    Offer::Shopify::ProductUpdater.perform_async(id)
  end
end
