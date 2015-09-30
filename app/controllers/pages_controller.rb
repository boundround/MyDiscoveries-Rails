class PagesController < ApplicationController

  def index
    # if !browser.modern?
    #     flash[:alert] = ("Please note that BoundRound does not support #{browser.name} version #{browser.version}. <br>
    #     We recommend upgrading to the latest <a href='https://chrome.google.com/' class='alert-link'>Google Chrome</a>,
    #     <a href='https://mozilla.org/firefox/' class='alert-link'>Firefox</a>,
    #      or <a href='http://windows.microsoft.com/ie' class='alert-link'>Internet Explorer.</a> <br>").html_safe
    # end
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
