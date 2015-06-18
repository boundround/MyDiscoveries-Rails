class PlacesController < ApplicationController
  
  before_action :redirect_if_not_admin, :except => [:show, :send_postcard, :mapdata, :search, :liked_places, :programsearch, :programsearchresultslist, :programsearchresultsmap, :placeprograms, :debug]

  def index
    @places = Place.all
    @areas = Area.all

    respond_to do |format|
      format.html
      format.json { render json: @places }  # respond with the created JSON object
    end
  end

  def debug
    render plain: "Host="+request.host+","+"Domain(1)="+request.domain(1)+", "+"Domain(2)="+request.domain(2)+" Subdomain="+request.subdomain()+"\n"+request.inspect
    #find_subdomain(request)
  end
  
  def search
    @places = Place.where.not(subscription_level: ['out', 'draft'])
             .text_search(params[:term]).includes(:area)

    # @places = Place.where("display_name @@ :q or description @@ :q", q: params[:term])
    @areas = Area.where("display_name @@ :q", q: params[:term])

    @places = ActiveSupport::JSON.decode(@places.to_json(include: :area))

    @areas = ActiveSupport::JSON.decode(@areas.to_json)

    both = @areas + @places

    respond_to do |format|
      format.json { render json: both.to_json}  # respond with the created JSON object
    end
  end

  def show
    @place = Place.includes(:games, :photos, :videos).friendly.find(params[:id])
    @area = Area.includes(places: [:photos, :games, :videos, :categories]).find(@place.area_id)

    if @place.subscription_level == "Premium" || @place.subscription_level == "draft"
      @videos = @place.videos.where.not(priority: 1) || []
      @hero_video = @place.videos.find_by(priority: 1)
    else
      @videos = []
    end

    if !@hero_video
      @hero_photo = @place.photos.find_by(priority: 1)
      @photos = @place.photos.where.not(priority: 1)
    else
      @photos = @place.photos
    end

    @area_videos = @place.area.videos
    @request_xhr = request.xhr?

    if @place.display_name == "Virgin Australia"
      @set_body_class = "virgin-body"
    end

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json { render json: @place }
    end
  end

  def create
    @place = Place.new(place_params)

    if @place.identifier == ''
      @place.identifier = @place.display_name.gsub(/\W/, '').downcase
    end

    if @place.save
      JournalInfo.create(place_id: @place.id)
      redirect_to :back, notice: 'Place succesfully saved'
    else
      redirect_to '/places#new', notice: 'Place not saved!'
    end
  end

  def new
    @place = Place.new
    @place.photos.build
    @areas = Area.all
  end

  def edit
    @place = Place.friendly.find(params[:id])
    @areas = Area.all
    @photos = @place.photos
    @photo = Photo.new
    @games = @place.games
    @videos = @place.videos
    @program = Program.new
    @discounts = @place.discounts
    @discount = Discount.new
  end

  def tags
    params[:sort] ||= "id"
    params[:direction] ||= "asc"
    @places = Place.order(params[:sort] + " " + params[:direction]).paginate(:per_page => 30, :page => params[:page])
  end

  def update
    @place = Place.friendly.find(params[:id])

    if @place.update(place_params)
      redirect_to :back, notice: 'Place succesfully updated'
    else
      redirect_to edit_place_path(@place), notice: 'Error: Place not updated'
    end

  end

  def destroy
  end

  def import
    Place.import(params[:file])
    redirect_to places_path, notice: "Places imported."
  end

  def send_postcard
    name = params[:name]
    email = params[:email]
    message = params[:message]
    photo = params[:photo]
    place = params[:place]
    area = params[:area]
    country = params[:country]
    Share.postcard(name, email, message, photo, place, area, country).deliver
    redirect_to :back, notice: 'Postcard sent'
  end

  def mapdata

    # geojson for MapBox map
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  def liked_places
    @places = {}
    @liked_places = Place.where.not(slug: params[:placeIds])

    @liked_places.each do |place|
      @places[place.slug] = like_icon(place)
    end

    respond_to do |format|
      format.json { render json: @places}
    end
  end

  def programsearch #xyrin index.html
    @placeprograms = "yes"
#    @places = Place.wherelimit(6).order('id asc')
    @places = Place.joins(:programs).order('id asc').distinct.limit(6)
    place_ids = @places.map{|x| x[:id]}
    @programs = Program.where("place_id IN (?)", place_ids)
    set_program_filters(@places)
#     render plain: @locations.inspect
  end
  
  def programsearchresultslist #xyrin search.html
    set_program_results_state(params)
  end
   
  def programsearchresultsmap #xyrin map.html
    set_program_results_state(params)
  end
   
  def placeprograms #xyrin result.html 
    @placeprograms = "yes"
    @place = Place.friendly.find(params[:id])
#     render plain: params.inspect
  end
  
  protected
    def set_program_results_state(params)
      @placeprograms = "yes"
    
      if params[:id] then
        @pplaces = Place.where('places.id = :id', id: params[:id])
        @zoom = 15
      else
          
        if params[:term] == "" then params[:term] = nil end
        @search_term = params[:term]
        if params[:location] == "" then params[:location] = nil end
        @location_filter = params[:location]
        if params[:subject] == "" then params[:subject] = nil end
        @subject_filter = params[:subject]
        if params[:activity] == "" then params[:activity] = nil end
        @activity_filter = params[:activity]
        if params[:yearlevel] == "" then params[:yearlevel] = nil end
        @yearlevel_filter = params[:yearlevel]
    
        if @search_term then
    #      @places = Place.joins(:programs).where.not(subscription_level: ['out', 'draft'])
    #               .text_search(@search_term).distinct
          @pplaces = Place.joins(:programs).where(
            #Faster
            'places.subscription_level NOT IN (:sl) AND 
            (places.display_name ILIKE :st OR programs.name ILIKE :st)', sl: ['out', 'draft'], st: '%'+@search_term+'%').distinct
            #Better
            # @pplaces = Place.joins(:programs).where(
            #   'places.subscription_level NOT IN (:sl) AND
            #   (places.display_name ILIKE :st OR places.description ILIKE :st
            #   OR programs.name ILIKE :st OR programs.description ILIKE :st)', sl: ['out', 'draft'], st: '%'+@search_term+'%').distinct
        else
          @pplaces = Place.joins(:programs).where.not(subscription_level: ['out', 'draft']).distinct
        end 
    #    render plain: @places.inspect              
      end
      
      @places = []
      @pplaces.each do |place|
        if !@location_filter || (place.area.display_name == @location_filter) then
          place.programs.each do |program|
            push_place = false
            if !@subject_filter || (program.programsubject_list.include? @subject_filter) then
              if !@activity_filter || (program.programactivity_list.include? @activity_filter) then
                if @yearlevel_filter then
                  if @yearlevel_filter == "K-2" then
                      if (program.programyearlevel_list.include? "K") || (program.programyearlevel_list.include? "1") || (program.programyearlevel_list.include? "2") then push_place = true end
                  elsif @yearlevel_filter ==  "3-4" then
                     if (program.programyearlevel_list.include? "3") || (program.programyearlevel_list.include? "4") then push_place = true end
                  elsif @yearlevel_filter ==  "5-6" then
                     if (program.programyearlevel_list.include? "5") || (program.programyearlevel_list.include? "6") then push_place = true end
                  elsif @yearlevel_filter ==   "7-8" then
                     if (program.programyearlevel_list.include? "7") || (program.programyearlevel_list.include? "8") then push_place = true end
                  elsif @yearlevel_filter ==   "9-10" then
                     if (program.programyearlevel_list.include? "9") || (program.programyearlevel_list.include? "10") then push_place = true end
                  elsif @yearlevel_filter ==   "11-12" then
                     if (program.programyearlevel_list.include? "11") || (program.programyearlevel_list.include? "12") then push_place = true end
                  end
                else  
                  push_place = true
                end
                if push_place then @places.push(place) end
                break if push_place
              end
            end
          end
        end
      end
      
      set_program_filters(@places)
    end

    def set_program_filters(places)
      place_ids = places.map{|x| x[:id]}
#      @locations = Area.joins(:places).where("places.id IN (?)", place_ids).distinct.map{|l| l[:display_name]}
      @locations = ["Sydney","Melbourne","Phillip Island","Canberra"]
      @locations.unshift('All')
      @yearlevels = ['All','K-2','3-4','5-6','7-8','9-10','11-12']
      @subjects = ['All','English', 'Mathematics', 'Science', 'History', 'Geography', 'Economics', 'Civics', 'Arts', 'Health','Languages']
      @categories = Category.all.map{|c| c[:name]}
      @categories.unshift('All')
    end
    
  private
    def place_params
      params.require(:place).permit(:code, :identifier, :display_name, :description, :booking_url, :display_address, :subscription_level,
                                    :latitude, :longitude, :logo, :phone_number, :website, :booking_url, :icon, :map_icon,
                                    :street_number, :route, :sublocality, :locality, :state, :country, :post_code, :phone_number,
                                    :passport_icon, :address, :area_id, :tag_list, :location_list, :activity_list, :place_id,
                                    photos_attributes: [:id, :place_id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :_destroy],
                                    videos_attributes: [:id, :vimeo_id, :priority, :place_id, :area_id, :_destroy],
                                    games_attributes: [:id, :url, :area_id, :place_id, :priority, :game_type, :_destroy],
                                    fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :_destroy],
                                    discounts_attributes: [:id, :description, :place_id, :area_id, :_destroy],
                                    category_ids: [])
    end
end
