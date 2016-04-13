class PagesController < ApplicationController

  def index
    @set_body_class = "white-body"
    #check
    #task psoude code = "Places To Go" == Place.where(is_area: true).order(like_percentage ASC).limit(6)
    @areas = Place.active.is_area.where(primary_area: true).includes(:country).order("countries.display_name asc").includes(:photos)
    @areas = @areas.paginate(page: params[:areas_page], per_page: 6)
    # @categories = PrimaryCategory.all.includes(:places => :subcategories).paginate(per_page: 10, page: params[:categories_page])
    # @primary_categories= PrimaryCategory.all.limit(3).paginate(per_page: 3, page: params[:primary_categories_page])
    @subcategories = Subcategory.subcats.includes(:places => :subcategories)
    @subcategories = @subcategories.sort {|x, y| y.places.size <=> x.places.size}
    @subcategories = @subcategories.paginate(per_page: 3, page: params[:subcategories_page])
  end

  def globe
    @initial_zoom = request.original_url
  end

  def google_map_home
    @set_body_class = "google_map_background"
#    @placeprograms = "yes"
  end

  def map_only
    @map = []
  end

  def want_notification
    @place = params[:place]
    @address = params[:address]

    Want.notification(@place, @address).deliver
    render :nothing => true
  end

  def terms
  end

  def privacy
  end

  def robots
    robot_type = ENV["BOUNDROUND_ENV"] == "boundround_production" ? "production" : "development"
    robots = File.read(Rails.root + "config/robots.#{robot_type}.txt")
    render :text => robots, :layout => false, :content_type => "text/plain"
  end



end
