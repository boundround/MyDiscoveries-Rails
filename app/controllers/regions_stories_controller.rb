class RegionsStoriesController < ApplicationController
  before_action :set_regions_story, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @regions_stories = RegionsStory.all
    respond_with(@regions_stories)
  end

  def show
    respond_with(@regions_story)
  end

  def new
    @regions_story = RegionsStory.new
    respond_with(@regions_story)
  end

  def edit
  end

  def create
    @regions_story = RegionsStory.new(regions_story_params)
    @regions_story.save
    respond_with(@regions_story)
  end

  def update
    @regions_story.update(regions_story_params)
    respond_with(@regions_story)
  end

  def destroy
    @regions_story.destroy
    respond_with(@regions_story)
  end

  private
    def set_regions_story
      @regions_story = RegionsStory.find(params[:id])
    end

    def regions_story_params
      params.require(:regions_story).permit(:region_id, :story_id)
    end
end
