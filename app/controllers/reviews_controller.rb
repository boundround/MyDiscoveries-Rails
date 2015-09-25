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
      NewReview.notification(@review).deliver
      redirect_to @reviewable, notice: "Thanks for your review! We'll let you know when others can see it too!"
    else
      redirect_to @reviewable
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
