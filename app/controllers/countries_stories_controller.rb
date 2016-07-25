class CountriesStoriesController < ApplicationController

  def create
    @story = Story.find_by_slug(params[:story_id])
    @story.countries = []
    if params[:countries_story]
      @country_ids = params[:countries_story][:country_ids]
      @country_ids.each do |id|
        @story.countries_stories.create(story_id: @story.id, country_id: id)
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
    @countries_stories = @story.countries.build
    @countries = Country.order(display_name: :asc)
  end

  def destroy
    @countries_story = CountriesStory.find_by(story_id: params["countries_stories"]["story_id"], country_id: params["countries_stories"]["country_id"])
    @countries_story.destroy
    render nothing: true
  end

  private
    def countries_stories_params
      params.require(:countries_stories).permit(:story_id, :country_ids => [])
    end

end
