class PlacesStoriesController < ApplicationController

  def create
    @story = Story.find_by_slug(params[:story_id])
    @story.places = []
    if params[:places_story]
      @place_ids = params[:places_story][:place_ids]
      @place_ids.each do |id|
        @story.places_stories.create(story_id: @story.id, place_id: id)
      end
    end

    redirect_to :back

  end

  def edit
  end

  def update
    @story = Story.find_by_slug(params[:story_id])
  end

  def index
    @story = Story.friendly.find(params[:story_id])
    @places_stories = @story.places.build
    @places = Place.active.where(is_area: true).order(display_name: :asc)
  end

  def destroy
    @places_story = PlacesStory.find_by(story_id: params["places_stories"]["story_id"], place_id: params["places_stories"]["place_id"])
    @places_story.destroy
    render nothing: true
  end

  private
    def places_stories_params
      params.require(:places_stories).permit(:story_id, :place_ids => [])
    end

end
