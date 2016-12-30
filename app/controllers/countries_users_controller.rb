class CountriesUsersController < ApplicationController
  def create
    @countries_user = CountriesUser.new(countries_user_params)
	if @countries_user.save
	  render nothing: true
	end
  end

  def destroy
    @countries_user = CountriesUser.find_by(country_id: params["countries_user"]["country_id"], user_id: params["countries_user"]["user_id"])
    @countries_user.destroy
    render nothing: true
  end

  private
	def countries_user_params
	  params.require(:countries_user).permit(:country_id, :user_id)
	end

end
