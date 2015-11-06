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
    respond_to do |format|
      if @review.save
        NewReview.delay.notification(@review)
        format.html { redirect_to :back, notice: "Thanks for the review. We'll let you know when others can see it too!" }
        format.js { }
      else
        format.html { redirect_to :back, notice: "We're sorry, there was an error. Please try your review again." }
        format.js { }
      end
    end
  end

  def edit
  end

  def update
    @review = Review.find(params[:id])

    if @review.update(review_params)
      @review.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @review }
    end
  end

  def destroy
  end

  private
    def load_reviewable
      resource, id = request.path.split("/")[1, 2]
      @reviewable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def review_params
      params.require(:review).permit(:content, :title, :user_id, :status, :google_place_id)
    end
end
