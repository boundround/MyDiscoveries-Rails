class StoriesController < ApplicationController
  before_action :find_story_by_slug, only: [:show]
  before_action :check_user_authorization, only: [:index, :create, :new]

  def index
    @stories = Story.all
  end

  def show
    @set_body_class = "white-background"
    @story = Story.find_by_slug(params[:id])
    @stories_like_this = @story.stories_like_this.paginate(page: params[:stories_page], per_page: 2)
    @places_to_visit = @story.attractions.active.paginate( page: params[:places_to_visit_page], per_page: 6 ) #this is not being used
    @region_stories = @story.regions.paginate( page: params[:stories_page], per_page: 3 )
    @latest_stories = Story.active.order(created_at: :desc).limit(2)
    @place_to_go = @story.regions[0].places.paginate(page: params[:places_to_go_page], per_page: 2 )
  end

  def feed
    @stories = Story.active.where('updated_at > ?', 3.days.ago).order(updated_at: :desc)
  end

  def paginate_place
    @story = Story.find_by_slug(params[:id])
    @places_to_visit = @story.attractions.active.paginate( page: params[:places_to_visit_page], per_page: 6 )
  end

  def seo_analysis
    @story = @search_optimizable = Story.friendly.find(params[:id])
    authorize @story
  end

  def destroy
    @story = Story.find_by_slug(params[:id])
    authorize @story

   if @story.destroy
      redirect_to  :back, notice: "Success"
   end
  end

  def index_new
    @stories = Story.where(user_id: current_user.id)
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to edit_story_path(@story), notice: "Your story has been saved."
    else
      flash.now[:error] = "Sorry, there was an error saving your story"
      render :new
    end
  end

  def autosave
    @story = Story.find params["story"]["story_id"]
    @test = {test1: "Stuff", test2: "Stuff 2"}
    @test = @test.to_json
    respond_to do |format|
      if @story.update(story_params)
        format.json { render json: @story }
        flash[:notice] = "Story autosaved."
      else
        flash[:notice] = "There was a problem autosaving your story."
      end
    end
  end

  def update
    @story = Story.friendly.find params[:id]
    authorize @story

    respond_to do |format|
      if @story.update(story_params)
        format.json do render json: @story
          flash.now[:success] = "Story autosaved."
        end
        format.html { redirect_to edit_story_path(@story), notice: "Story saved" }

      else
        redirect_to edit_story_path(@story), notice: "error"
      end
    end

  end

  def edit
    @story = Story.find_by_slug(params[:id])
    @story_photos = @story.photos
    authorize @story
  end

  def upload_image
    story_image = StoryImage.create(file: params[:files].first, story_id: params[:id])
    render json: { files: [{ url: story_image.file.url }] }
  end

  def delete_image
    story_images = StoryImage.where(story_id: params[:id])
    story_image = story_images.detect { |si| si.file.url == params[:file] }
    story_image.destroy
    head :ok
  end

  def update_hero
    @story = Story.find(params[:id])
    photo_id = params[:photo_id]

    @story.photos.each do |photo|
      if photo.id.to_s.eql? photo_id
         photo.hero = true
      else
        photo.hero = false
      end
        photo.save
    end

    @story.save # needed to update search index
    redirect_to choose_hero_story_photos_path(@story)
  end

  def featured
    @story = Story.find(params[:story][:id])
    if @story.update(story_params)
      render nothing: true
    end
  end

  private
    def set_story
      @story = Story.find_by_slug(params[:id])
    end
    def load_storiable
      resource, id = request.path.split("/")[1, 2]
      @storiable = resource.singularize.classify.constantize.friendly.find(id)
    end

    def story_params
      params.require(:story).permit(:content, :title, :user_id, :author_id, :status, :google_place_id, :storiable_id, :country_id,
                                    :seo_title,
                                    :excerpt,
                                    :focus_keyword,
                                    :meta_description, :canonical_url,
                                    :age_bracket, :author_name, :public, :date, :publish_date, :minimum_age, :maximum_age,
                                    :seo_friendly_url, :primary_category_id, :hero_image, :featured,
                                    photos_attributes: [:id, :photoable_id, :photoable_type, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
                                    subcategory_ids: [])
    end

    def set_story_as_draft
      if params[:story].present?
        params[:commit].to_s.downcase.eql?('publish') ? status= 'live' : status= 'draft'
        params[:story][:status]= status
      end
    end

    def find_story_by_slug
      @story = Story.friendly.find(params[:id])
      $flashhh = nil
      if request.path != story_path(@story)
        return redirect_to @story, :status => :moved_permanently
      end
    end
end
