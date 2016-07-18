class PostsUsersController < ApplicationController

  def create
    posts_user = PostsUser.new(posts_user_params)

    if posts_user.save
      render nothing: true
    end
  end

  def destroy
    posts_user = PostsUser.find_by(post_id: params["posts_user"]["post_id"], user_id: params["posts_user"]["user_id"])
    posts_user.destroy
    render nothing: true
  end

  private
    def posts_user_params
      params.require(:posts_user).permit(:post_id, :user_id)
    end

end
