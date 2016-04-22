class StoriesController < ApplicationController
  before_filter :load_storiable, :except => :profile_create
  before_action :set_story_as_draft, only: [:create, :update]
  before_action :set_user_photos, only: [:create, :update]
  before_action :set_story, only: [:index, :edit, :update, :show, :destroy]
  before_action :set_body, only: [:new_story, :index_new, :edit_story, :show]

  def index
    @stories = @storiable.stories
  end

  def show;end

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

  def profile_create
    @story = Story.new(story_params)
    place = Place.find_by(place_id: @story.google_place_id)
    if place
      @story.storiable = place
    end

    if @story.save
      NewStory.notification(@story).deliver
      redirect_to users_stories_path, notice: "Thanks for the story. We'll let you know when others can see it too!"
    else
      redirect_to users_stories_path, notice: "We're sorry, there was an error uploading your story."
    end
  end

  def edit;end

  def update
    if params[:add_country]
      @story.country_id = @story.storiable.country_id 
    else
      @story.country_id = nil
    end
    if @story.update(story_params)
      redirect_to place_story_path(@story.storiable, @story)
    
    # respond_to do |format|
    #   format.html { redirect_to :back }
    #   format.json { render json: @story }
    # end
    end
  end

  def destroy
   if @story.destroy
      redirect_to  :back, notice: "Success"   
   end 
  end

  def index_new
    @stories = Story.where(user_id: current_user.id)
  end

  def new_story
    place = Place.find_by_slug(params[:id])
    @new_story = place.stories.new
  end
  def create_story
    place = Place.find_by_slug(params[:id])
    @new_story = place.stories.new(story_params)
    if @new_story.save
      redirect_to place_story_url(@new_story.storiable, @new_story), notice: "success"
    else
      redirect_to :back, notice: "error"
    end
  end

  def update_story
    @new_story = Story.find(params[:story_id])
    if @new_story.update(story_params)
      redirect_to place_story_url(@new_story.storiable, @new_story), notice: "success"
    else
      redirect_to :back, notice: "error"
    end
    
  end

  def edit_story
    @new_story = Story.find(params[:story_id])
  end
  def new_destroy
    
  end
  def set_body
    @set_body_class ="bg-white"
  end

  private
    def set_story
      @story = Story.find(params[:id])
    end
    def load_storiable
      resource, id = request.path.split("/")[1, 2]
      # @storiable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def story_params
      params.require(:story).permit(:content, :title, :user_id, :status, :google_place_id, :storiable_id, :country_id, :age_bracket, :author_name, :date,
                                    user_photos_attributes: [:id, :title, :content, :user_id, :story_id, :story_priority, :place_id, :path, :status])
    end

    def set_story_as_draft
      if params[:story].present?
        params[:commit].to_s.downcase.eql?('publish') ? status= 'live' : status= 'draft'
        params[:story][:status]= status
      end
    end

    def set_user_photos
      if params[:story].present?
        if params[:files]
          if params.traverse(:story, :user_photos_attributes).blank?
            params[:story][:user_photos_attributes] = {}
          end
          indexlala= 0
          unless params[:story][:user_photos_attributes].blank?
            indexlala= params[:story][:user_photos_attributes].keys.last.to_i + 1
          end
          params[:files].each do |file|
            params[:story][:user_photos_attributes][indexlala.to_s]= { path: file, user_id: current_user.id }
            indexlala= indexlala+1
          end
        end
      end
    end
end
