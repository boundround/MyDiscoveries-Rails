class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy, :update_hero]

  def index
    @regions = Region.all
  end

  def show
    @videos = Video.first
    @stories  = @region.stories.active.reverse.paginate(page: params[:stories_page], per_page: 6 )
    @areas  = Place.first
    @photos = Photo.first
    @countries = @region.children.select {|child| child.class.to_s == "Country"}.paginate(page: params[:countries_page], per_page: 12 )
    @famous_faces = ''
    @fun_facts  = ''
    @fun_facts = @region.fun_facts
    @places_to_visit_map = @region.all_place_children
    #@places_to_visit = @region.attractions.paginate(page: params[:places_to_visit_page], per_page: 3 )
    @place_to_go = @region.places.paginate(page: params[:places_to_go_page], per_page: 3 )
    @offers = @region.products.active.order(:name).paginate(page: params[:offers_page], per_page: 4)
  end

  def new
    @region = Region.new
    @countries = Country.all
    @regions = Region.all
  end

  def edit
    @countries = Country.all
    @regions = Region.where.not(id: @region.id)
  end

  def create
    @region = Region.new(region_params)
    if @region.save
      redirect_to edit_region_path(@region), notice: 'Region succesfully saved'
    else
      render action: :new, notice: 'Region not saved!'
    end
  end

  def update
    if @region.update(region_params)
      respond_to do |format|
        format.json { render json: @region }
        format.html do
          redirect_to edit_region_path(@region), notice: 'Region succesfully updated'
        end
      end
    else
      redirect_to :back
    end
  end

  def destroy
    @region.destroy
    respond_to do |format|
      format.html { redirect_to regions_url, notice: 'Region was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_hero
    photo_id = params[:photo_id]
    @region.photos.each do |photo|
      if photo.id.to_s.eql? photo_id
         photo.hero = true
      else
        photo.hero = false
      end
        photo.save
    end
    @region.save

    redirect_to choose_hero_region_photos_path(@region)

  end

  def paginate_offers
    @region = Region.find_by_slug(params[:id])
    @offers = @region.products.active.order(:name).paginate(page: params[:offers_page], per_page: 4)
  end

  def paginate_place_to_visit
    @region = Region.find_by_slug(params[:id])
    #@places_to_visit = @region.attractions.paginate( page: params[:places_to_visit_page], per_page: 3 )
  end

  def paginate_place_to_go
    @region = Region.find_by_slug(params[:id])
    @place_to_go = @region.places.paginate(page: params[:place_to_go_page], per_page: 3 )
  end

  def paginate_stories
    @region = Region.find_by_slug(params[:id])
    @stories  = @region.stories.active.reverse.paginate(page: params[:stories_page], per_page: 6 )
  end

  def paginate_countries
    @region = Region.find_by_slug(params[:id])
    @countries = @region.children.select {|child| child.class.to_s == "Country"}.paginate(page: params[:countries_page], per_page: 12 )
  end

  private
  def set_region
    @region = Region.friendly.find(params[:id])
  end

  def region_params
    if @region.present?
        unless @region.parent.blank?
          if (@region.parent.parentable_type == params[:region][:parent_attributes][:parentable_type])&&(@region.parent.parentable_id == params[:region][:parent_attributes][:parentable_id].to_i)
            params[:region].delete :parent_attributes

          elsif (@region.parent.parentable_type == params[:region][:parent_attributes][:parentable_type])||(@region.parent.parentable_id == params[:region][:parent_attributes][:parentable_id].to_i)
            @region.parent.delete()

          elsif params[:region][:parent_attributes][:parentable_type] == nil
            @region.parent.delete()
            params[:region].delete :parent_attributes
          else
            @region.parent.delete()
          end
        end
      end

    params.require(:region).permit(:display_name, :description, :latitude, :longitude, :zoom_level, :no_parent_select, :status,
      parent_attributes: [:parentable_id, :parentable_type],
      photos_attributes: [:id, :place_id, :photoable_id, :photoable_type, :attraction_id, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
      videos_attributes: [:id, :vimeo_id, :youtube_id, :transcript, :hero, :priority, :title, :description, :place_id, :videoable_id, :videoable_type, :attraction_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
      fun_facts_attributes: [:id, :content, :reference, :priority, :place_id, :attraction_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy]
    )
  end
end
