class CountriesPostsController < ApplicationController

  def create
    @post = Post.find_by_slug(params[:post_id])
    @post.countries = []
    if params[:countries_post]
      @country_ids = params[:countries_post][:country_ids]
      @country_ids.each do |id|
        @post.countries_posts.create(post_id: @post.id, country_id: id)
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
    @countries_posts = @post.countries.build
    @countries = Country.order(display_name: :asc)
  end

  def destroy
    @countries_post = CountriesPost.find_by(post_id: params["countries_posts"]["post_id"], country_id: params["countries_posts"]["country_id"])
    @countries_post.destroy
    render nothing: true
  end

  private
    def countries_posts_params
      params.require(:countries_posts).permit(:post_id, :country_ids => [])
    end

end
