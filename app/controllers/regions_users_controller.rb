class RegionsUsersController < ApplicationController
  def create
	@regions_user = RegionsUser.new(regions_user_params)

	if @regions_user.save
	  render nothing: true
	end
  end

  def destroy
	@regions_user = RegionsUser.find_by(region_id: params["regions_user"]["region_id"], user_id: params["regions_user"]["user_id"])
	@regions_user.destroy
	render nothing: true
  end

  private
	def regions_user_params
	  params.require(:regions_user).permit(:region_id, :user_id)
	end

end
