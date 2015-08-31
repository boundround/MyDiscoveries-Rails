class ReviewsController < ApplicationController
  before_filter :load_reviewable

  def index
    @reviews = @reviewable.reviews
  end

  def show
  end

  def new
    @review = @reviewable.reviews.new
  end

  def create
    @review = @reviewable.reviews.new(review_params)
    if @review.save
      redirect_to @reviewable, notice: "Thanks for your review! We'll let you know when others can see it too!"
    else
      redirect_to @reviewable
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def load_reviewable
      resource, id = request.path.split("/")[1, 2]
      @reviewable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def review_params
      params.require(:review).permit(:content, :title, :user_id, :status)
    end
end
