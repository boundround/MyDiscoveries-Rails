class StoriesUsersController < ApplicationController

  def create
    @stories_user = StoriesUser.new(stories_user_params)

    if @stories_user.save
      render nothing: true
    end
  end

  def destroy
    @stories_user = StoriesUser.find_by(story_id: params["stories_user"]["story_id"], user_id: params["stories_user"]["user_id"])
    @stories_user.destroy
    render nothing: true
  end

  private
    def stories_user_params
      params.require(:stories_user).permit(:story_id, :user_id)
    end

end
