class PlacesPostsController < ApplicationController
  include ApplicationHelper

  def create
    @post = Post.find_by_slug(params[:post_id])
    @post.places = []
    if params[:places_post]
      @place_ids = params[:places_post][:place_ids]
      @place_ids.each do |id|
        @post.places_posts.create(post_id: @post.id, place_id: id)
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
    @places_posts = @post.places.build
    all_places_posts = @post.places
    @places = destination_available(Place.active, all_places_posts)
  end

  def destroy
    @places_post = PlacesPost.find_by(post_id: params["places_posts"]["post_id"], place_id: params["places_posts"]["place_id"])
    @places_post.destroy
    render nothing: true
  end

  private
    def places_posts_params
      params.require(:places_posts).permit(:post_id, :place_ids => [])
    end

end
