class StoriesController < ApplicationController

  def index
    @stories = Story.all
  end

  def show
    @story = Story.find_by_slug(params[:id])
  end

  def update
    if @story.update(story_params)
      redirect_to :back
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

  def new
    @new_story = Story.new
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to @story, notice: "Your story has been saved."
    else
      render :new, notice: "Sorry, there was an error saving your story"
    end
  end

  def update
    @story = Story.find_by_slug(params[:id])
    if @story.update(story_params)
      redirect_to :back, notice: "Succesfully Updated Story"
    else
      redirect_to :back, notice: "error"
    end

  end

  def edit
    @story = Story.find_by_slug(params[:id])
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
      params.require(:story).permit(:content, :title, :user_id, :status, :google_place_id, :storiable_id, :country_id,
                                    :age_bracket, :author_name, :public, :date, :publish_date, :minimum_age, :maximum_age,
                                    :primary_category_id, subcategory_ids: [])
    end

    def set_story_as_draft
      if params[:story].present?
        params[:commit].to_s.downcase.eql?('publish') ? status= 'live' : status= 'draft'
        params[:story][:status]= status
      end
    end
end
