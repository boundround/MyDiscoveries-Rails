class ReviewsUsersController < ApplicationController

  def create
    @reviews_user = ReviewsUser.new(reviews_user_params)

    if @reviews_user.save
      render nothing: true
    end
  end

  def destroy
    @reviews_user = ReviewsUser.find_by(review_id: params["reviews_user"]["review_id"], user_id: params["reviews_user"]["user_id"])
    @reviews_user.destroy
    render nothing: true
  end

  private
    def reviews_user_params
      params.require(:reviews_user).permit(:review_id, :user_id)
    end

end
