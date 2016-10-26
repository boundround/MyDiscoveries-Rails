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
    @stories = Post.all_active_posts
    @stories += Story.all_active_stories
    @stories = @stories.sort {|x, y| y.publish_date <=> x.publish_date}
    @stories = @stories.paginate(page: params[:stories_page], per_page: 6)
    #@stories = Post.active.order(created_at: :desc).paginate(page: params[:stories_page], per_page: 6)
  end

  def show
    @set_body_class = "white-body"
    @post = Post.find_by_slug(params[:id])
    @places_to_visit = @post.places.order(:display_name, :id).paginate( page: params[:places_to_visit_page], per_page: 6 )
    # subcategories = @post.subcategories.map { |category| category.name }
    # subcategories = subcategories.join(" ").gsub(/\W/, " ")
    # results = Post.raw_search(subcategories)
    # @posts_like_this = []
    # results["hits"].each do |post|
    #   @posts_like_this << Post.find(post["objectID"].gsub("post_", "").to_i)
    # end
    # @post.places.each {|place| @posts_like_this << place.posts}
    # @posts_like_this = @posts_like_this.flatten.uniq.delete_if {|post| post == @post}
    # @stories = @posts_like_this.paginate(page: params[:stories_page], per_page: 6)
  end

  def paginate
    @stories = Post.all_active_posts
    @stories += Story.all_active_stories
    @stories = @stories.paginate(page: params[:stories_page], per_page: 2)
  end

  def paginate_place_to_visit
    @post = Post.find_by_slug(params[:id])
    @places_to_visit = @post.places.order(:display_name, :id).paginate( page: params[:places_to_visit_page], per_page: 6 )
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :credit, :user_id, :status, :publish_date, :seo_friendly_url, :minimum_age, :maximum_age, :hero_photo, :primary_category_id, subcategory_ids: [])
    end
end
