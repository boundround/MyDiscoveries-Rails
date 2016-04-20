class PostsSubcategoriesController < ApplicationController
  def create
    @post = Post.find_by_slug(params[:post_id])
    @post.subcategories = []
    if params[:subcategories_post]
      @subcategory_ids = params[:posts_subcategories][:subcategory_ids]
      @subcategory_ids.each do |id|
        @post.posts_subcategories.create(post_id: @post.id, subcategory_id: id)
      end
    end

    redirect_to :back

  end

  def edit
  end

  def update
    @post = Post.find_by_slug(params[:post_id])
  end

  def index
    @post = Post.friendly.find(params[:post_id])
    @posts_subcategories = @post.subcategories.build
    @subcategories = Subcategory.all
  end

  def destroy
    @subcategories_post = PostsSubcategory.find_by(post_id: params["subcategories_posts"]["post_id"], subcategory_id: params["posts_subcategories"]["subcategory_id"])
    @subcategories_post.destroy
    render nothing: true
  end

  private
    def subcategories_posts_params
      params.require(:posts_subcategories).permit(:post_id, :subcategory_ids => [])
    end
end
