class PagesController < ApplicationController

  def index
    @set_body_class = "home-page background"
    areas = Place.active.is_area.where(primary_area: true).includes(:country).order("countries.display_name asc").includes(:photos)
    @areas = areas.paginate(page: params[:areas_page], per_page: 3)
    @subcategories = Subcategory.subcats.includes(:places => :subcategories)
    @subcategories = @subcategories.sort {|x, y| y.places.size <=> x.places.size}
    @subcategories = @subcategories.paginate(per_page: 4, page: params[:subcategories_page])
    @category1 = @subcategories[0]
    @category2 = @subcategories[1]
    @category3 = @subcategories[2]
    @category4 = @subcategories[3]
    @sydney = Place.find_by_display_name("Sydney")
  end

  def globe
    @initial_zoom = request.original_url
  end

  def google_map_home
    @set_body_class = "google_map_background"
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
