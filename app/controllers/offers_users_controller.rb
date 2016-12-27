class OffersUsersController < ApplicationController
  def create
    @offers_user = OffersUser.new(offers_user_params)
	if @offers_user.save
	  render nothing: true
	end
  end

  def destroy
    @offers_user = OffersUser.find_by(offer_id: params["offers_user"]["offer_id"], user_id: params["offers_user"]["user_id"])
    @offers_user.destroy
    render nothing: true
  end

  private
	def offers_user_params
	  params.require(:offers_user).permit(:offer_id, :user_id)
	end

end
