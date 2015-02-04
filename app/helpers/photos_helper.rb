module PhotosHelper

  def alt_tag_for(photo)
    unless photo.alt_tag.nil?
      photo.alt_tag
    else
      unless photo.area.nil?
        "Fun Activity Photo #{photo.id} - #{photo.area.display_name}"
      else
        "Fun Activity Photo #{photo.id} - #{photo.place.display_name}"
      end
    end
  end

end
