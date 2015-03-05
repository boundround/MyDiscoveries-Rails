module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Bound Round"
    if page_title.empty?
      base_title + " | Fun Travel and Activities for Kids"
    else
      "Fun Travel and Activities for Kids and Families In #{page_title} | #{base_title}"
    end
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

  def category_color_for(place)
    case place.categories[0].identifier
      when 'animals'
        '#ff9280'
      when 'activity'
        '#fa8383'
      when 'beach'
        '#ffcf7b'
      when 'museum'
        '#7994b1'
      when 'park'
        '#9ff1ab'
      when 'place_to_eat'
        '#76a15a'
      when 'place_to_stay'
        '#a0dcda'
      when 'shopping'
        '#aab7f4'
      when 'sights'
        '#f2a1bc'
      when 'sport'
        '#d6abe8'
      when 'theme_park'
        '#9dd0f0'
      else
        '#f2a1bc'
    end
  end

  def like_icon(content)
    if current_user
      if content.users.include?(current_user)
        "<img class='like-icon' src='#{asset_path ('star_white.png')}' data-user='#{current_user.id}' data-photo-id='#{content.id}'>"
      else
        "<img class='like-icon' src='#{asset_path ('star_grey.png')}' data-user='#{current_user.id}' data-photo-id='#{content.id}'>"
      end
    end
      "<img class='like-icon' src='#{asset_path ('star_grey.png')}' data-user='' data-photo-id='#{content.id}'>"
  end

end
