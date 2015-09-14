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
      NewStory.notification(@story).deliver
      redirect_to @storiable, notice: "Thanks for the story. We'll let you know when others can see it too!"
    else
      redirect_to :back, notice: "We're sorry, there was an error uploading your story."
    end
  end

  def edit
  end

  def update
    @story = Story.find(params[:id])

    if @story.update(story_params)
      @story.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @story }
    end
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