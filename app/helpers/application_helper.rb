module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

  def full_title(page_title = '')
    base_title = "Bound Round"
    if page_title.empty?
      base_title + " | Fun Travel and Activities for Kids"
    else
      "#{page_title} Fun Activities for Traveling Kids and Families | #{base_title}"
    end
  end

  def draw_hero_background(place)
    if place.photos.blank?
      if place.categories.blank?
        "https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_sights.jpg"
      else
        '"https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_"' + place.categories[0].identifier + '".jpg"'
      end
    else
      place.photos.find_by(priority: 1) ? place.photos.find_by(priority: 1).path_url(:large) : place.photos.first.path_url(:large)
    end
  end

  def open_graph_image
      placeholder = "https://blooming-earth-8066-herokuapp-com.global.ssl.fastly.net/assets/br_logo_new-30eb3b9bb0267503159d6cab93191844.png"

      if @place && !@place.photos.blank?
        photo = @place.photos.first.path_url
      elsif @area && !@area.photos.blank?
        photo = @area.photos.first.path_url
      elsif @country && !@country.photos.blank?
        photo = @country.photos.first.path_url
      end

      if photo
        return "<meta property='og:image' content='#{photo.gsub('https://', 'http://') }' />\n" + "<meta property='og:image:secure_url' content='#{photo}' />\n" + "<meta property='og:image:type' content='image/jpeg' />"
      else
        return "<meta property='og:image' content='#{ placeholder.gsub('https://', 'http://') }' />\n" + "<meta property='og:image:secure_url' content='#{placeholder}' />\n" + "<meta property='og:image:type' content='image/jpeg' />"
      end
  end

  def get_random_place_photo(place)
    if place.photos.length > 0
      photo = place.photos[rand(0...place.photos.length)]
      if photo
        photo.path_url(:small)
      end
    else
      "generic-grey.jpg"
    end
  end

  def extract_domain(url)
    domain = ""
    if !url.blank? && url != "http://"
      if url.index("://")
        domain = url.split('/')[2]
      else
        domain = url.split('/')[0]
      end
    end
    domain = domain.split(':')[0]
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
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
    postPath = content.class.to_s.pluralize.downcase + '_' + 'users'
    postType = postPath.singularize
    postType = 'fun_facts_user' if postType == 'funfacts_user'
    postPath = 'fun_facts_users' if postPath == 'funfacts_users'

    if user_signed_in?
      if content.users.include?(current_user)
        return "<img class='like-icon' src='#{asset_path ('star_yellow.png')}' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='true' data-switch-image='#{asset_path('star_grey.png')}'>"
      else
        return "<img class='like-icon' src='#{asset_path ('star_grey.png')}' data-post-path=#{postPath} data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='false' data-switch-image='#{asset_path('star_white.png')}'>"
      end
    end
      "<img class='like-icon' src='#{asset_path ('star_grey.png')}'>"
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def approve_icon(content)
    postPath = content.class.to_s.pluralize.downcase
    postType = postPath.singularize
    postType = 'fun_fact' if postType == 'funfact'
    postPath = 'fun_facts' if postPath == 'funfacts'

    if content.customer_review == true
      return "<i class='disapprove-icon fa fa-thumbs-o-down fa-2x' data-toggle='modal' data-target='#thumbsDownModal' data-asset-type='#{postType}' data-asset-id='#{content.id}' data-place-id='#{content.place.id.to_s}'></i>" +
              "<i class='approve-icon customer-approve fa fa-thumbs-o-up fa-2x' data-post-path='#{postPath}' data-post-type='#{postType}' data-content-id='#{content.id}'></i>"
    else
      return ""
    end
  end

  def asset_owner_link(asset)
    if asset.place
      "<a href='/places/#{asset.place.slug}'>#{asset.place.display_name}</a>"
    elsif asset.area
      "<a href='/places/#{asset.area.slug}'>#{asset.area.display_name}</a>"
    elsif asset.countries
      "<a href='/places/#{asset.countries.first.slug}'>#{asset.countries.first.display_name}</a>"
    end
  end

  def thumbnail_for(content)
    if content.class.to_s == "Photo" || content.class.to_s == "UserPhoto"
      asset_path(content.path_url(:small))
    elsif content.class.to_s == "FunFact"
      asset_path(content.hero_photo_url)
    elsif content.class.to_s == "Game"
      game_thumbnail(content)
    else
      ""
    end
  end

  def show_place_rating(place)
    rating = place.quality_average.avg.round
    remainder = 5-rating
    text = ""
    rating.times do
      text += '<i class="fa fa-heart"></i>'
    end
    remainder.times do
      text += '<i class="fa fa-heart-o"></i>'
    end

    text

  end

  def get_user_place_rating_from_review(review)
    if Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id).length > 0
      Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id)[0].stars.round
    else
      0
    end
  end

end
