class RegionsStoriesController < ApplicationController

  def create
    @story = Story.find_by_slug(params[:story_id])
    
    @story.regions = []
    if params[:regions_story]
      @regions_ids = params[:regions_story][:region_ids]
      @regions_ids.each do |id|
        @story.regions_stories.create(story_id: @story.id, region_id: id)
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
    @regions_stories = @story.regions.build
    @regions = Region.order(display_name: :asc)
  end

  def destroy
    @regions_story = RegionsStory.find_by(story_id: params["regions_stories"]["story_id"], region_id: params["regions_stories"]["region_id"])
    @regions_story.destroy
    render nothing: true
  end

  private
  def regions_story_params
    params.require(:regions_stories).permit(:story_id, :region_ids => [])
  end

end
