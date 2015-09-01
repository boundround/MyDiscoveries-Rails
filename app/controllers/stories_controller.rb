class StoriesController < ApplicationController
  before_filter :load_storiable

  def index
    @stories = @storiable.stories
  end

  def show
  end

  def new
    @story = @storiable.reviews.new
    @story.user_photos.build
  end

  def create
    @story = @storiable.stories.new(story_params)
    if @story.save
      redirect_to @storiable, notice: "Thanks for the story. We'll let you know when others can see it too!"
    else
      redirect_to :back, notice: "We're sorry, there was an error uploading your story."
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def load_storiable
      resource, id = request.path.split("/")[1, 2]
      @storiable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def story_params
      params.require(:story).permit(:content, :title, :user_id, :status,
                                    user_photos_attributes: [:id, :title, :content, :user_id, :story_id, :story_priority, :place_id, :path, :status])
    end
end
