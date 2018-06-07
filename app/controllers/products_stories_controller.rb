class ProductsStoriesController < ApplicationController
  before_action -> { check_user_authorization('ProductsStory') }, only: %w(
    index create destroy
  )

  def index
    @stories_products = product.stories.build
    @stories = Story.active.order(title: :asc)
  end

  def create
    product.stories = []
    add_product_stories if params[:stories_products]
    redirect_to :back
  end

  def destroy
    ProductsStory.find_by(
      product_id: params[:stories_products][:product_id],
      story_id: params[:stories_products][:story_id]
    )&.destroy

    render nothing: true
  end

  private
  def product
    @product ||= Spree::Product.friendly.find(params[:product_id])
  end

  def add_product_stories
    story_ids.each do |id|
      product.products_stories.create(story_id: id)
    end
  end

  def story_ids
    @story_ids ||= params[:stories_products][:story_ids]
  end
end
