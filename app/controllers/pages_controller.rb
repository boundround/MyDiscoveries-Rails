class PagesController < ApplicationController

  def index
    @set_body_class = "white-body"
    @videos = Video.order(created_at: :desc).limit(6)
    @photos = UserPhoto.order(created_at: :desc).limit(6)
    @reviews = Review.order(created_at: :desc).limit(6)
    @stories = Story.order(created_at: :desc).limit(6)
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
    @city = params[:city]
    @country = params[:country]
    @userIP = params[:userIP]

    SuggestedPlace.create(user_ip: @userIP, place: @place, city: @city, country: @country)

    Want.notification(@place, @city, @country).deliver
    render :nothing => true
  end

  def terms
  end

  def privacy
  end



end

'SELECT * FROM (SELECT DISTINCT ON (videos.vimeo_id) * FROM videos ORDER BY videos.created_at) top_titles ORDER BY events.copy_count DESC LIMIT 99'
