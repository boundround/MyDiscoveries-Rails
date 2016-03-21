class PagesController < ApplicationController

  def index
    @set_body_class = "white-body"
    # @last_20_videos = Video.active.order(created_at: :desc).limit(20)
    # @last_20_videos = Video.find_by_sql("SELECT videos.* FROM videos WHERE videos.status = 'live' AND (videos.youtube_id = '') ORDER BY videos.created_at DESC LIMIT 20")
    # @videos = @last_20_videos.to_a.uniq {|video| video.vimeo_id}
    # @photos = UserPhoto.active.includes(:place).where('path is not null').where('user_photos.place_id is not null').joins(:place).where("places.status = 'live'").order(created_at: :desc).limit(20)
    # @reviews = Review.active.includes(:reviewable).order(created_at: :desc).limit(5)
    # @stories = Story.active.includes(:storiable).order(created_at: :desc).limit(5)
    # @leaders = PointsBalance.order(balance: :desc).includes(:user => :roles).limit(20)
    # @leaderboard = []
    # @leaders.each do |leader|
    #   unless leader.user.roles.length > 0 || leader.user.admin
    #     @leaderboard.push leader
    #   end
    # end
    # @leaderboard = @leaderboard[0..5]
    #check
    #task psoude code = "Places To Go" == Place.where(is_area: true).order(like_percentage ASC).limit(6)
    @places_to_go =  Place.is_area.limit(18).includes(:photos).paginate(page: params[:places_to_go_page], per_page: 6)
    @categories = PrimaryCategory.all.includes(:places => :subcategories).paginate(per_page: 10, page: params[:categories_page])
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
