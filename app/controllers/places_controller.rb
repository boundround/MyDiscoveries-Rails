class PlacesController < ApplicationController
  layout false, :only => :wp_blog

  def new
    @place = Place.new
    @place.photos.build
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

  def edit
    @set_body_class = "br-body"
    @place = Place.friendly.find(params[:id])
    @photo = Photo.new
    @program = Program.new
    @discount = Discount.new
    @blogs = ApiBlog.get_cached_blogs(@place.slug)
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

      if params[:place][:hero_image].present? || params[:place][:remote_hero_image_url].present?
        render :crop
      else
        redirect_to :back, notice: 'Place succesfully updated'
      end

    else
      redirect_to edit_place_path(@place), notice: 'Error: Place not updated'
    end
  end

  def refresh_blog
    @place = Place.find_by_slug(params[:id])
    Rails.cache.delete(@place.slug)
    redirect_to :back, notice: "Blog posts for #{@place.display_name} have been refreshed"
  end

  def new_edit
    @set_body_class = "br-body"
    @place = Place.friendly.find(params[:id])
    @three_d_video = ThreeDVideo.new
  end

  def destroy
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

  def geoquery
    @place_areas = Place.active.pluck(:display_name, :id, :place_id, :subscription_level, :status, :updated_at)

    respond_to do |format|
      format.json { render json: @place_areas }  # respond with the created JSON object
    end
  end

  def hero_image_picker
    @place = Place.friendly.find(params[:id])
  end

  def merge
  end

  def index
    @places = Place.select(:display_name, :id, :place_id, :subscription_level, :status, :updated_at, :is_area, :slug, :top_100).where.not(status: "removed")

    respond_to do |format|
      format.html
      format.json { render json: @places }  # respond with the created JSON object
    end
  end

  def all_edited

    @all_edited = Place.joins(:photos).where("photos.status = 'edited'")
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
      place.fun_facts.edited.each do |fun_fact|
        @all_content.push fun_fact
      end
      place.discounts.edited.each do |discount|
        @all_content.push discount
      end
    end

  end

  def search
    @places = Place.where.not(subscription_level: ['out', 'draft'])
             .text_search(params[:term])

    # @places = Place.where("display_name @@ :q or description @@ :q", q: params[:term])

    @places = ActiveSupport::JSON.decode(@places.to_json)

    respond_to do |format|
      format.json { render json: @places.to_json}  # respond with the created JSON object
    end
  end

  def show

    #we dont need includes methods here, because we are not use it on views and some instance variable are not needed because we are not use it on views
    #we can use local variable if we are not use it on views
    @reviewable = @place = Place.find_by_slug(params[:id])
    # @place_blog = @place.blog_request\

    # Details information
    @optimum_times = @place.subcategories.best_visited
    @durations = @place.subcategories.duration
    @subcategories = @place.subcategories.subcategory
    @accessibilities = @place.subcategories.accessibility
    @prices = @place.subcategories.price

    @more_places = Place.where(primary_category: @place.primary_category).limit(6)
    @related_places = Place.is_area
    @reviewable = @place
    @reviews = @reviewable.reviews.active
    # debugger

    if user_signed_in?
      @user_reviews_not_public = @reviewable.reviews.where('status = ? OR ((status = ? OR status = ?) AND user_id = ?)', "live", "draft", "user", current_user.id)
    else
      @reviews = @reviewable.reviews.active
    end

    # if !@user_reviews_not_public.blank?
    #   @reviews += @user_reviews_not_public
    # end
    @review = Review.new

    @storiable = @place
    api_blogs = ApiBlog.get_cached_blogs(@place.slug)
    @stories = @storiable.stories.active + api_blogs

    @stories.sort{|x, y| x.created_at <=> y.created_at}.reverse.first(6)

    @story = Story.new
    @user_photos = @story.user_photos.build
    @active_user_photos = @place.user_photos.active
    # distance = 20
    # center_point = [@place.latitude, @place.longitude]
    # box = Geocoder::Calculations.bounding_box(center_point, distance)
    # @nearby_places = Place.within_bounding_box(box)
    # @nearby_places = @place.nearbys(20).active.includes(:photos, :categories, :quality_average, :user_photos)

    # @top_places = @nearby_places.sort do |x, y|
    #   (y.average("quality") ? y.average("quality").avg : 0) <=> (x.average("quality") ? x.average("quality").avg : 0)
    # end

    # @top_places = @top_places[0..4]

    # categories = @place.categories.map {|category| category.id}
    # @similar_places = @place.nearbys(30).active.includes(:photos, :categories).where('categorizations.category_id' => categories)

    if @place.subscription_level == "Premium"
      @hero_video = @place.videos.find_by(hero: true) || @place.videos.find_by(priority: 1)
    end

    ##########################
    # Get all photos and videos for this place and sort by created at date
    # @all_photos_and_videos = []
    # @place.videos.active.each do |video|
    #   if !video.hero
    #     @all_photos_and_videos << video
    #   end
    # end
    # @place.photos.active.each do |photo|
    #   @all_photos_and_videos << photo
    # end
    # @active_user_photos.each do |photo|
    #   @all_photos_and_videos << photo
    # end
    # @all_photos_and_videos.sort {|x, y| x.created_at <=> y.created_at}

    #NEW
    @videos = @place.videos.active.order('created_at DESC')
    @photos = @place.photos.active.includes(:users, :place) + @active_user_photos

    # @place.videos.active.each do |video|
    #     @videos << video
    # end

    # @place.photos.active.each do |photo|
    #   @photos << photo
    # end
    # @active_user_photos.each do |photo|
    #   @photos << photo
    # end

    @photos.sort {|x, y| x.created_at <=> y.created_at}
    # @videos.sort {|x, y| x.created_at <=> y.created_at}
    ###############################

    @request_xhr = request.xhr?

    if @place.display_name == "Virgin Australia"
      @set_body_class = "virgin-body"
    end

    view = if @place.is_area?
      "area"
    else
      "place"
    end

    respond_to do |format|
      format.html { render view, :layout => !request.xhr? }
      format.json { render json: @place }
    end

  end

  def transfer_assets
    if user_signed_in? && current_user.admin?
      @from_place = Place.find(params[:place][:from_place_id])
      @to_place = Place.find(params[:place][:to_place_id])

      if params[:remove] == true
        @from_place.status = "removed"
      end

      @from_place.photos.each do |photo|
        photo.place_id = @to_place.id
        unless photo.save
          raise "Photo #{photo.id} not transferred"
        end
      end

      @from_place.games.each do |game|
        game.place_id = @to_place.id
        unless game.save
          raise "Game #{game.id} not transferred"
        end
      end

      @from_place.videos.each do |photo|
        video.place_id = @to_place.id
        unless video.save
          raise "Video #{video.id} not transferred"
        end
      end

      @from_place.reviews.each do |review|
        review.reviewable = @to_place
        unless review.save
          raise "Review not transferred"
        end
      end

      @from_place.stories.each do |story|
        story.reviewable = @to_place
        unless story.save
          raise "Story #{story.id} not transferred"
        end
      end

      @from_place.user_photos.each do |photo|
        photo.place_id = @to_place.id
        unless photo.save
          raise "Photo #{photo.id} not transferred"
        end
      end
    end
  end

  def user_created
    @places = Place.where(user_created: true).reorder(:created_at)
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

  def tags
    params[:sort] ||= "id"
    params[:direction] ||= "asc"
    @places = Place.order(params[:sort] + " " + params[:direction]).paginate(:per_page => 30, :page => params[:page])
  end

############################################################################
############################################################################
# Below are controller actions for School Safari (www.schoolsafari.com)
# At some point we need to split these code bases.
# For the time being, if you are working on Bound Round,
# be careful when altering the code below.
#
#############################################################################
#############################################################################

  def debug
    render plain: "Host="+request.host+","+"Domain(1)="+request.domain(1)+", "+"Domain(2)="+request.domain(2)+" Subdomain="+request.subdomain()+"\n"+request.inspect
    #find_subdomain(request)
  end

  def placeareasmapdata
    # geojson for MapBox map
    @placeareas_geojson = Place.all_placeareas_geojson

    respond_to do |format|
      format.html
      format.json { render json: @placeareas_geojson }  # respond with the created JSON object
    end
  end

  def check_all_boundround
    Rails.cache.fetch('all_bound_round_places') do
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
# By ID, moving to SEO friendly 26/10/2015
#    set_program_constants()
#    @placeprograms = "yes"
#    puts "Trying to find"+params[:id]
#    @place = Place.find(params[:id])
#    puts "Found"+params[:id]

    set_program_constants()
    @placeprograms = "yes"

    puts "Trying to find"+params[:id]
    if(params[:id] =~ /\A\d+\z/)
      @place = Place.find(params[:id])
    else
      @place = Place.find_by_slug(params[:id])
    end
    puts "Found"+params[:id]

#    @place = Place.friendly.find(params[:id])
#     render plain: params.inspect
  end


  def wp_blog
    @blog = ApiBlog.find_blog_id(params[:id].to_i, params[:place])
    # debugger
    # @place = Place.includes(:games, :photos, :videos).find_by_slug(params[:place])
    @place = Place.find_by_slug(params[:place])
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
      filtering_programs = false

      # params.each do |pa|
      #   params[pa[0]] = CGI.decode(pa[1])
      #   puts params[pa[0]]
      # end

      if params[:term] == "" then
        params[:term] = nil
        @search_term = nil
      else
        @search_term = URI.decode(params[:term])
      end

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
          filtering_programs = true
          full_query = "places.status IN (:pstatus) and programs.id in ("+full_query+")"
        else
          full_query = "places.status IN (:pstatus) and ((places.show_on_school_safari is true) or (places.show_on_school_safari is false and programs.id is not null)) "
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
          place_query = '(places.display_name ILIKE :st OR programs.name ILIKE :st) AND ' + full_query

          if filtering_programs then
            @places = Place.joins(:photos,:programs).includes(:photos).where(place_query, pstatus: "live", st: '%'+@search_term+'%', lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).distinct.limit(@MAX_TO_RETURN)
          else
            #Do outer left join if want places that may not have programs but still want to see
            @places = Place.joins(:photos).includes(:photos, :programs).where(place_query, pstatus: "live", st: '%'+@search_term+'%', lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).distinct.limit(@MAX_TO_RETURN)
          end

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
          if filtering_programs then
            @places = Place.joins(:photos,:programs).includes(:photos).where(full_query, pstatus: "live", lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).limit(@MAX_TO_RETURN)
          else
            #Do outer left join if want places that may not have programs but still want to see
            @places = Place.joins(:photos).includes(:photos, :programs).where(full_query, pstatus: "live", lf: "%"+@lf+"%", sf: @subject_filter, sa: @activity_filter, syl: yl_array_from_range(@yearlevel_filter)).order(:display_name).limit(@MAX_TO_RETURN)
          end

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

##############################################################################
#
# END OF SCHOOL SAFARI PLACES CONTROLLER ACTIONS
#
###############################################################################

  private
    def place_params
      params.require(:place).permit(
        :code,
        :identifier,
        :display_name,
        :description,
        :show_on_school_safari,
        :school_safari_description,
        :booking_url,
        :display_address,
        :subscription_level,
        :latitude,
        :longitude,
        :logo,
        :phone_number,
        :website,
        :booking_url,
        :icon,
        :map_icon,
        :published_at,
        :unpublished_at,
        :minimum_age,
        :maximum_age,
        :street_number,
        :route,
        :sublocality,
        :locality,
        :state,
        :post_code,
        :created_by,
        :user_created,
        :hero_image,
        :remote_hero_image_url,
        :crop_x,
        :crop_y,
        :crop_h,
        :crop_w,
        :customer_approved,
        :customer_review,
        :approved_at,
        :country_id,
        :bound_round_place_id,
        :short_description,
        :primary_category_id,
        :passport_icon,
        :address,
        :area_id,
        :tag_list,
        :location_list,
        :activity_list,
        :place_id,
        :status,
        :is_area,
        :special_requirements,
        :top_100,
        :viator_link,
        photos_attributes: [:id, :place_id, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        videos_attributes: [:id, :vimeo_id, :youtube_id, :transcript, :hero, :priority, :title, :description, :place_id, :area_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
        fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        discounts_attributes: [:id, :description, :place_id, :area_id, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        user_photos_attributes: [:id, :title, :path, :caption, :hero, :story_id, :priority, :user_id, :place_id, :area_id, :status, :google_place_id, :google_place_name, :instagram_id, :remote_path_url, :_destroy],
        three_d_videos_attributes: [:link, :caption, :place_id],
        subcategory_ids: [])
    end
end
