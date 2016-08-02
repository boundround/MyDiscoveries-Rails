class PagesController < ApplicationController
  require 'will_paginate/array'
  before_action :set_cache_control_headers, only: :index

  def index
    @page = Page.find_by title: "home"
    @set_body_class = "home-page background"
    @areas = Place.home_page_areas.paginate(page: params[:areas_page], per_page: 3)
    @subcategories = Subcategory.subcats
    @subcategories = @subcategories.sort {|x, y| y.places.size <=> x.places.size}
    @subcategories = @subcategories.paginate(per_page: 4, page: params[:subcategories_page])
    @all_posts = Post.all_active_posts
    @all_stories = Story.all_active_stories
    @stories = (@all_posts + @all_stories).sort {|x, y| y.publish_date <=> x.publish_date}
    @stories = @stories.paginate(page: params[:stories_page], per_page: 2)
    @sydney = Place.find 1064
    @category1 = @subcategories[0]
    @category2 = @subcategories[1]
    @category3 = @subcategories[2]
    @category4 = @subcategories[3]
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
  end

  def all_pages
    @pages = Page.all
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

  private
    def page_params
      params.require(:story).permit(:title, :hero_image, :hero_image_text, :brief_headline, :page_header)
    end



end
