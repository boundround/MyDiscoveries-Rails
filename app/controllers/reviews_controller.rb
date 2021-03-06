class ReviewsController < ApplicationController
  before_filter :load_reviewable
  before_action :set_review, only: [:edit, :update, :show]

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
        message = "Thanks for the review. We'll let you know when others can see it too!"
        format.html { redirect_to :back, notice: message }
        format.js { flash[:notice] = message }
      else
        message = "We're sorry, there was an error. Please try your review again."
        format.html { redirect_to :back, notice: message }
        format.js { flash[:notice] = message }
      end
    end
  end

  def edit;end

  def update
    if params[:add_country]
      @review.country_id = @review.reviewable.country_id
    else
      @review.country_id = nil
    end
    if @review.update(review_params)
      if @review.reviewable.is_a? Place
        redirect_to place_review_path(@review.reviewable, @review)
      else
        redirect_to offer_review_path(@review.reviewable, @review)
      end
    end
  end

  def destroy
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end
    def load_reviewable
      resource, id = request.path.split("/")[1, 2]
      @reviewable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def review_params
      params.require(:review).permit(:content, :title, :user_id, :status, :google_place_id, :reviewable_id)
    end
end
