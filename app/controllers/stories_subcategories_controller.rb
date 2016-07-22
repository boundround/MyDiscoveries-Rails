class StoriesSubcategoriesController < ApplicationController
  def create
    @story = Story.find_by_slug(params[:story_id])
    @story.subcategories = []
    if params[:subcategories_story]
      @subcategory_ids = params[:stories_subcategories][:subcategory_ids]
      @subcategory_ids.each do |id|
        @story.stories_subcategories.create(story_id: @story.id, subcategory_id: id)
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
    @story_subcategories = @story.subcategories.build
    @subcategories = Subcategory.all
  end

  def destroy
    @subcategories_story = StoriesSubcategory.find_by(story_id: params["subcategories_stories"]["story_id"], subcategory_id: params["stories_subcategories"]["subcategory_id"])
    @subcategories_story.destroy
    render nothing: true
  end

  private
    def subcategories_stories_params
      params.require(:stories_subcategories).permit(:story_id, :subcategory_ids => [])
    end
end
