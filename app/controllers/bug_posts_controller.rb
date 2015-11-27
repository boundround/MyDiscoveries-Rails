class BugPostsController < ApplicationController
  def index
    @bug_posts = BugPost.all
  end

  def new
    @bug_post = BugPost.new
  end

  def create
    @bug_post = BugPost.new(bug_post_params)
    @bug_post.save
  end

  def show
    @bug_post = BugPost.find(params(:id))
  end

  def edit
    @bug_post = BugPost.find(params(:id))
  end

  def update
    @bug_post = BugPost.find(params(:id))
  end

  def destroy
    @bug_post = BugPost.find(params(:id))
  end

  private
    def bug_post_params
      params.require(:bug_post).permit(:description, :user_id, :author, :screen_shot)
    end
end
