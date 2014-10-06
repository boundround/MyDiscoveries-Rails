module VideosHelper
  def video_place_link(video)
    if video.place
      link_to video.place.display_name, place_path(video.place.id)
    else
      link_to video.area.display_name, area_path(video.area.id)
    end
  end
end
