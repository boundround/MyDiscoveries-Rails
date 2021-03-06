class PostsController < ApplicationController
  before_action :check_user_authorization, only: [:index, :create, :new, :update, :edit, :destroy]

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to posts_path, notice: "Post Created"
    else
      render :new, notice: "Sorry, there was an error created your \"Post\"."
    end
  end

  def update
    @post = Post.friendly.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "Post Updated"
    else
      render :edit, notice: "Sorry, there was an error updating this post"
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "Post Deleted"
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.friendly.find(params[:id])
  end

  def index
    @posts = Post.all
  end

  def all_posts
    @stories = Story.active.includes(:user).order(publish_date: :desc).order(created_at: :desc)
    @stories = @stories.paginate(page: params[:stories_page], per_page: 6)
  end

  def show
    @set_body_class = "white-body"
    @post = Post.find_by_slug(params[:id])
  end

  def paginate
    @stories = Story.active.includes(:user).order(publish_date: :desc).order(created_at: :desc)
    @stories = @stories.paginate(page: params[:stories_page], per_page: 6)
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :credit, :user_id, :status, :publish_date, :seo_friendly_url, :minimum_age, :maximum_age, :hero_photo, :primary_category_id, subcategory_ids: [])
    end
end
