module VideosHelper
  def video_place_link(video)
    if video.place and video.place.area
      link_to (video.place.display_name + ', ' + video.place.area.display_name), place_path(video.place.id)
    elsif video.area
      link_to video.area.display_name, area_path(video.area.id)
    end
  end

  def area_place_video_link(video)
    link_to video.place.display_name, place_path(video.place.id)
  end
end
