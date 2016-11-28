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

  def video_embed_code(video)
    @videoable = nil

    if video.videoable.present?
      @videoable = video.videoable
    elsif video.countries.present?
      @videoable = video.countries.first
    end

    "<iframe frameborder='0'
              webkitallowfullscreen
              mozallowfullscreen
              allowfullscreen
              width='420'
              height='240'
              src='https:/www.boundround.com/#{@videoable.class.to_s.pluralize.downcase}/#{@videoable.id rescue ""}/videos/#{video.id}'></iframe>"
  end
end
