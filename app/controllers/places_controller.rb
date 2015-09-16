class PlacesController < ApplicationController

  # before_action :redirect_if_not_admin, :except => [:show, :send_postcard, :mapdata, :search, :liked_places, :programsearch, :programsearchresultslist, :programsearchresultsmap, :placeprograms, :debug]

  def index
    @places = Place.joins(:area).pluck(:display_name, :id, :place_id, :subscription_level, :status, :updated_at, "areas.display_name AS area_name")

    @no_area = Place.where(area_id: nil).pluck(:display_name, :id, :place_id, :subscription_level, :status, :updated_at)

    @places = @places + @no_area
    # @areas = Area.includes(:places => [:categories, :versions])

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
    @reviewable = @place
    @reviews = @reviewable.reviews.active
    @review = Review.new

    @storiable = @place
    @stories = @storiable.stories.active
    @story = Story.new
    @user_photos = @story.user_photos.build
    @active_user_photos = UserPhoto.active.where(place_id: @place.id)

    # distance = 20
    # center_point = [@place.latitude, @place.longitude]
    # box = Geocoder::Calculations.bounding_box(center_point, distance)
    # @nearby_places = Place.within_bounding_box(box)
    @nearby_places = @place.nearbys(20).active.includes(:games, :videos, :photos, :categories)

    @top_places = @nearby_places.sort do |x, y|
      (y.average("quality") ? y.average("quality").avg : 0) <=> (x.average("quality") ? x.average("quality").avg : 0)
    end

    @top_places = @top_places[0..4]

    categories = @place.categories.map {|category| category.id}
    @similar_places = @place.nearbys(30).active.includes(:games, :videos, :photos, :categories).where('categorizations.category_id' => categories)

    if @place.subscription_level == "Premium"
      @hero_video = @place.videos.find_by(priority: 1)
    end

    @videos_photos = @place.videos
    @videos_photos += @place.photos

    @request_xhr = request.xhr?

    if @place.display_name == "Virgin Australia"
      @set_body_class = "virgin-body"
    end

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json { render json: @place }
    end
  end

  def preview
    @place = Place.includes(:games, :photos, :videos).friendly.find(params[:id])
    if @place.area_id
      @area = Area.includes(places: [:photos, :games, :videos, :categories]).find(@place.area_id)
      @area_videos = @place.area.videos
    end

    if @place.subscription_level == "Premium"
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

    @request_xhr = request.xhr?

    if @place.display_name == "Virgin Australia"
      @set_body_class = "virgin-body"
    end

    respond_to do |format|
      format.html { render 'preview', :layout => !request.xhr? }
      format.json { render json: @place }
    end
  end

  def all_edited

    @all_edited = Place.joins(:photos).where("photos.status = 'edited'")
    @all_edited += Place.joins(:games).where("games.status = 'edited'")
    @all_edited += Place.joins(:videos).where("videos.status = 'edited'")
    @all_edited += Place.joins(:fun_facts).where("fun_facts.status = 'edited'")
    @all_edited += Place.joins(:discounts).where("discounts.status = 'edited'")

    @all_edited = @all_edited.uniq

    @all_content = []

    @all_edited.each do |place|
      place.photos.edited.each do |photo|
        @all_content.push photo
      end
      place.videos.edited.each do |video|
        @all_content.push video
      end
      place.games.edited.each do |game|
        @all_content.push game
      end
      place.fun_facts.edited.each do |fun_fact|
        @all_content.push fun_fact
      end
      place.discounts.edited.each do |discount|
        @all_content.push discount
      end
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

  def user_create
    existing_place = Place.find_by(place_id: params[:place][:place_id]) || Area.find_by(google_place_id: params[:place][:place_id]) || Country.find_by(display_name: params[:place][:display_name])
    if existing_place.class.to_s == "Place"
      render :json => {place_id: place_path(existing_place) }
    elsif existing_place.class.to_s == "Area"
      render :json => {place_id: area_path(existing_place) }
    elsif existing_place.class.to_s == "Country"
      render :json => {place_id: country_path(existing_place) }
    else
      @place = Place.new(place_params)
      country = ""
      address_components = params[:address_components]

      address_components.each do |k, v|
        v["types"].each do |type|
          if type == "country"
            country = Country.find_by country_code: v["short_name"]
            @place.country = country
          end
        end
      end

      if user_signed_in?
        @place.created_by = current_user.id.to_s
        @place.user_id = current_user.id
        if current_user.has_role?("publisher") || current_user.has_role?("editor") || current_user.has_role?("contributor") || current_user.admin?
          @place.status = "live"
        else
          @place.status = "draft"
        end
      else
        @place.created_by = "Guest User"
        @place.status = "guest"
      end

      if @place.save
        NewPlace.delay.notification(@place)
        JournalInfo.create(place_id: @place.id)
        render :json => {place_id: @place.id}
      else
        render :json => {place_id: "error" }
      end
    end
  end

  def user_created
    @places = Place.where(user_created: true)
  end

  def new
    @place = Place.new
    @place.photos.build
    @areas = Area.all
  end

  def edit
    @set_body_class = "br-body"
    @place = Place.friendly.find(params[:id])
    @areas = Area.select(:id, :display_name).order(:display_name)
    @photo = Photo.new
    @program = Program.new
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

      @place.photos.each do |photo|
        photo.add_or_remove_from_country(@place.country)
      end

      @place.videos.each do |video|
        video.add_or_remove_from_country(@place.country)
      end

      @place.fun_facts.each do |fun_fact|
        fun_fact.add_or_remove_from_country(@place.country)
      end

      @place.discounts.each do |discount|
        discount.add_or_remove_from_country(@place.country)
      end

      redirect_to :back, notice: 'Place succesfully updated'

    else
      redirect_to edit_place_path(@place), notice: 'Error: Place not updated'
    end

  end

  def destroy
  end

  def publishing_queue
  end

  def import
    Place.import(params[:file])
    redirect_to places_path, notice: "Places imported."
  end

  def send_postcard
    name = params[:name]
    email = params[:customer]
    message = params[:message]
    photo = params[:photo]
    place = params[:place]
    area = params[:area]
    country = params[:country]
    Share.postcard(name, email, message, photo, place, area, country).deliver
    redirect_to :back, notice: 'Postcard sent'
  end

  def content_rejected
    place_id = params["place-id"].to_i
    asset_type = params["asset-type"]
    asset_id = params["asset-id"]
    email = params["email"]
    comments = params["comments"]
    ContentRejected.send_rejected(place_id, asset_type, asset_id, email, comments)
    redirect_to :back, notice: 'Thank you. Comments sent'
  end

  def mapdata

    # geojson for MapBox map
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  def check_all_boundround
    Rails.cache.fetch('all_bound_round_places') do
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
    @max_feature_places = 6
#    @places = Place.wherelimit(6).order('id asc')
    @places = Place.joins(:programs).order('id asc').distinct.limit(@max_feature_places)
    place_ids = @places.map{|x| x[:id]}
    @programs = Program.where("place_id IN (?)", place_ids)
    set_program_filters(@places)
#     render plain: @locations.inspect
  end

  def programsearchresultslist #xyrin search.html
    set_program_results_sql(params)
#    set_program_results_state(params)
  end

  def programsearchresultsmap #xyrin map.html
    set_program_results_sql(params)
#    set_program_results_state(params)
  end

  def placeprograms #xyrin result.html
    set_program_constants()
    @placeprograms = "yes"
    puts "Trying to find"+params[:id]
    @place = Place.find(params[:id])
    puts "Found"+params[:id]
#    @place = Place.friendly.find(params[:id])
#     render plain: params.inspect
  end

  protected
    def yl_array_from_range(yl_range)
      if yl_range == "F-2" then
        ["F","K","1","2"]
      elsif @yearlevel_filter ==  "3-4" then
        ["3","4"]
      elsif @yearlevel_filter ==  "5-6" then
        ["5","6"]
      elsif @yearlevel_filter ==   "7-8" then
        ["7","8"]
      elsif @yearlevel_filter ==   "9-10" then
        ["9","10"]
      elsif @yearlevel_filter ==   "11-12" then
        ["11","12"]
      end
    end

    def set_program_results_sql(params)
      @MAX_TO_RETURN = 40
      @placeprograms = "yes"

      # params.each do |pa|
      #   params[pa[0]] = CGI.decode(pa[1])
      #   puts params[pa[0]]
      # end

      if params[:term] == "" then params[:term] = nil end
      @search_term = params[:term]

      if params[:id] then
        @places = Place.where('places.id = :id', id: params[:id])
        @programs = @places[0].programs
        @zoom = 15
      else
        full_query = ""
        if params[:subject] == "" then params[:subject] = nil end
        @subject_filter = params[:subject]
        if @subject_filter != nil then
          subject_sql = "(select g.taggable_id from tags as t, taggings as g where t.id = g.tag_id and g.context='programsubjects' and t.name ILIKE :sf )"
          full_query = full_query + subject_sql;
        end

        if params[:activity] == "" then params[:activity] = nil end
        @activity_filter = params[:activity]
        if @activity_filter != nil then
          activity_sql = "(select g.taggable_id from tags as t, taggings as g where t.id = g.tag_id and g.context='programactivities' and t.name ILIKE :sa )"
          if full_query != "" then
            full_query = full_query + " INTERSECT " + activity_sql;
          else
            full_query = activity_sql;
          end
        end

        if params[:yearlevel] == "" then params[:yearlevel] = nil end
        @yearlevel_filter = params[:yearlevel]
        if @yearlevel_filter != nil then
          yl_sql = "(select g.taggable_id from tags as t, taggings as g where t.id = g.tag_id and g.context='programyearlevels' and t.name in (:syl) )"
          if full_query != "" then
            full_query = full_query + " INTERSECT " + yl_sql;
          else
            full_query = yl_sql;
          end
        end

        if full_query != "" then
          full_query = "places.status IN (:pstatus) and programs.id in ("+full_query+")"
        else
          full_query = "places.status IN (:pstatus)"
        end

        if params[:location] == "" then params[:location] = nil end
        @location_filter = params[:location]
        @lf = ""
        if @location_filter != nil then
          @lf = @location_filter
          #This is intentionally not an ILIKE, state names like WA will match any "wa"
          location_sql = " places.address LIKE :lf "
          full_query = location_sql+" AND "+full_query
        end

        if @search_term then
          place_query = '(places.display_name ILIKE :st OR programs.name ILIKE :st OR areas.display_name ILIKE :st) AND ' + full_query

          @places = Place.joins(:area, :programs,:photos,:categories).includes(:area, :photos, :categories).where(place_query, pstatus: "live", st: '%'+@search_term+'%', lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).distinct.limit(@MAX_TO_RETURN)
          @places.each do |p|
            puts p.display_name
          end
            #Better
            # @pplaces = Place.joins(:programs).where(
            #   'places.subscription_level NOT IN (:sl) AND
            #   (places.display_name ILIKE :st OR places.description ILIKE :st
            #   OR programs.name ILIKE :st OR programs.description ILIKE :st)', sl: ['out', 'draft'], st: '%'+@search_term+'%').distinct

          full_query = "(programs.name ILIKE :st OR programs.description ILIKE :st) AND " + full_query
          @programs = Program.joins(:place,:webresources).includes(:webresources, {place: [:photos]}, :programyearlevels, :programactivities, :programsubjects).where(full_query, pstatus: "live", st: '%'+@search_term+'%', lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:name).limit(@MAX_TO_RETURN)
          @programs.each do |qp|
            puts qp.name
          end
        else
#          @places = Place.joins(:area, :programs, :photos, :categories).includes(:programs, :area, :photos, :categories).where(full_query, pstatus: "live", lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).limit(@MAX_TO_RETURN)
          @places = Place.joins(:area, :programs,:photos,:categories).includes(:area, :photos, :categories).where(full_query, pstatus: "live", lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).limit(@MAX_TO_RETURN)
          @places.each do |p|
            puts p.display_name
          end
          @programs = Program.joins(:place,:webresources).includes(:webresources, {place: [:photos]}, :programyearlevels, :programactivities, :programsubjects).where(full_query, pstatus: "live", lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:name).limit(@MAX_TO_RETURN)
          @programs.each do |qp|
            puts qp.name
          end
        end
    #    render plain: @places.inspect
      end

      set_program_filters(@places)
    end


    def set_program_results_state(params)
      @MAX_TO_RETURN = 400
      @placeprograms = "yes"

      if params[:term] == "" then params[:term] = nil end
      @search_term = params[:term]

      if params[:id] then
        @pplaces = Place.where('places.id = :id', id: params[:id])
        @pprograms = @pplaces[0].programs
        @zoom = 15
      else
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

#          @pplaces = Place.joins(:area,:program).pluck(:display_name, :id, :place_id, :subscription_level, :status, :updated_at, "areas.display_name AS area_name")
#          @pprograms = Program.joins(:place,:area).pluck("places.status", "places.id as place_id","places.display_name AS place_name","areas.display_name AS area_name","programs.name AS program_name").where(
#          "places.status IN(:sl) AND
#          (place_name ILIKE :st OR program_name ILIKE :st OR area_name ILIKE :st)', sl: "live", st: '%'+@search_term+'%').distinct")

          @pplaces = Place.includes(:area, :programs, :photos, :categories).joins(:area, :programs).where(
            #Faster
            'places.status IN (:sl) AND
            (places.display_name ILIKE :st OR programs.name ILIKE :st OR areas.display_name ILIKE :st)', sl: "live", st: '%'+@search_term+'%').distinct.limit(@MAX_TO_RETURN)
            #Better
            # @pplaces = Place.joins(:programs).where(
            #   'places.subscription_level NOT IN (:sl) AND
            #   (places.display_name ILIKE :st OR places.description ILIKE :st
            #   OR programs.name ILIKE :st OR programs.description ILIKE :st)', sl: ['out', 'draft'], st: '%'+@search_term+'%').distinct

          @pprograms = Program.includes(:webresources, :place, :programyearlevels, :programactivities, :programsubjects).joins(:place).where('places.status IN (:sl) AND (programs.name ILIKE :st OR programs.description ILIKE :st)', sl: "live", st: '%'+@search_term+'%').limit(@MAX_TO_RETURN)
        else
          @pplaces = Place.joins(:programs).includes(programs: [:programyearlevels, :programactivities, :programsubjects, :webresources]).where(status: "live").distinct.limit(@MAX_TO_RETURN)
          @pprograms = Program.includes(:webresources, :place, :programyearlevels, :programactivities, :programsubjects).joins(:place).where('places.status IN (:sl)', sl: "live").limit(@MAX_TO_RETURN)
        end
    #    render plain: @places.inspect
      end

      @places = []
      @pplaces.each do |place|
        if !@location_filter || (place.address.downcase.include? @location_filter) then
          place.programs.each do |program|
            push_place = false
            if !@subject_filter || (program.programsubject_list.join(", ").downcase.include? @subject_filter.downcase) then
              if !@activity_filter || (program.programactivity_list.join(", ").downcase.include? @activity_filter.downcase) then
                if @yearlevel_filter then
                  if @yearlevel_filter == "K-2" then
                      if (program.programyearlevel_list.include? "F") || (program.programyearlevel_list.include? "K") || (program.programyearlevel_list.include? "1") || (program.programyearlevel_list.include? "2") then push_place = true end
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

      @programs = []
      @pprograms.each do |program|
        push_program = false
        if !@location_filter || (program.place.address.downcase.include? @location_filter.downcase) then
          if !@subject_filter || (program.programsubject_list.join(",").downcase.include? @subject_filter.downcase) then
            if !@activity_filter || (program.programactivity_list.join(",").downcase.include? @activity_filter.downcase) then
              if @yearlevel_filter then
                if @yearlevel_filter == "F-2" then
                    if (program.programyearlevel_list.include? "K") || (program.programyearlevel_list.include? "F") || (program.programyearlevel_list.include? "1") || (program.programyearlevel_list.include? "2") then push_program = true end
                elsif @yearlevel_filter ==  "3-4" then
                   if (program.programyearlevel_list.include? "3") || (program.programyearlevel_list.include? "4") then push_program = true end
                elsif @yearlevel_filter ==  "5-6" then
                   if (program.programyearlevel_list.include? "5") || (program.programyearlevel_list.include? "6") then push_program = true end
                elsif @yearlevel_filter ==   "7-8" then
                   if (program.programyearlevel_list.include? "7") || (program.programyearlevel_list.include? "8") then push_program = true end
                elsif @yearlevel_filter ==   "9-10" then
                   if (program.programyearlevel_list.include? "9") || (program.programyearlevel_list.include? "10") then push_program = true end
                elsif @yearlevel_filter ==   "11-12" then
                   if (program.programyearlevel_list.include? "11") || (program.programyearlevel_list.include? "12") then push_program = true end
                end
              else
                push_program = true
              end
              if push_program then @programs.push(program) end
              break if @programs.count > @MAX_TO_RETURN
            end
          end
        end
      end

      set_program_filters(@places)
    end

    def set_program_constants()
      @locations = Rails.cache.fetch("australian_statesq_filter",expires_in: 4.hours) do
#        locs = Place.includes(:country).where("countries.display_name ILIKE '%australia%' AND length(places.state)>4").pluck('DISTINCT places.state')
        locs = Place.includes(:country).where("countries.display_name ILIKE '%australia%' AND length(places.state)>=2").pluck('DISTINCT places.state')
        locs.unshift("All")
        locs
      end
#      @locations.unshift('All')
      @ylvec = ['F','K','1','2','3','4','5','6','7','8','9','10','11','12']
      @yearlevels = ['All','F-2','3-4','5-6','7-8','9-10','11-12']
#      @subjects = ['All','English', 'Mathematics', 'Science', 'History', 'Geography', 'Economics', 'Civics', 'Arts', 'Health','Languages']
      @subjects = ["All","Arts","Business & Enterprise","Education","English","Geography","Health & Physical Education","History","Language","Mathematics","Science","Society & Environment","Technology"]
    end

    def set_program_filters(places)
#      place_ids = places.map{|x| x[:id]}
#      @locations = Area.joins(:places).where("places.id IN (?)", place_ids).distinct.map{|l| l[:display_name]}
      set_program_constants()
#      @categories = Category.all.map{|c| c[:name]}
#      @categories.unshift('All')
      @categories = ["All", "Excursion", "Incursion", "Virtual Excursion"]
    end

  private
    def place_params
      params.require(:place).permit(:code, :identifier, :display_name, :description, :booking_url, :display_address, :subscription_level,
                                    :latitude, :longitude, :logo, :phone_number, :website, :booking_url, :icon, :map_icon, :published_at, :unpublished_at,
                                    :street_number, :route, :sublocality, :locality, :state, :post_code, :created_by, :user_created,
                                    :customer_approved, :customer_review, :approved_at, :country_id,
                                    :passport_icon, :address, :area_id, :tag_list, :location_list, :activity_list, :place_id, :status,
                                    photos_attributes: [:id, :place_id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
                                    videos_attributes: [:id, :vimeo_id, :priority, :title, :description, :place_id, :area_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
                                    games_attributes: [:id, :url, :area_id, :place_id, :priority, :game_type, :status, :customer_approved, :customer_review, :approved_at, :_destroy],
                                    fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
                                    discounts_attributes: [:id, :description, :place_id, :area_id, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
                                    category_ids: [])
    end
end
