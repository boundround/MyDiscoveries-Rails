class AttractionsStoriesController < ApplicationController

  def create
    @story = Story.find_by_slug(params[:story_id])
    @story.attractions = []
    if params[:attractions_story]
      @attractions_ids = params[:attractions_story][:attraction_ids]
      @attractions_ids.each do |id|
        @story.attractions_stories.create(story_id: @story.id, attraction_id: id)
      end
    end

    redirect_to :back
  end

  def edit;end

  def update
    @story = Story.find_by_slug(params[:story_id])
  end

  def index
    @story = Story.friendly.find(params[:story_id])
    @attractions_stories = @story.attractions.build
    @attractions = Attraction.active.order(display_name: :asc)
  end

  def destroy
    @attractions_story = AttractionsStory.find_by(story_id: params["attractions_stories"]["story_id"], attraction_id: params["attractions_stories"]["attraction_id"])
    @attractions_story.destroy
    render nothing: true
  end

  private
    def attractions_stories_params
      params.require(:attractions_stories).permit(:story_id, :attraction_ids => [])
    end

end