module ApplicationHelper

  def draw_prices(prices)
    prices_string = ""

    if prices.any? {|price| price.name == "Free"}
      prices_string += "<span data-toggle='tooltip' title data-original-title='Free' class='green-font price'>Free</span>"
    else
      prices_string += "<span data-toggle='tooltip' title data-original-title='Free' class='grey-font price'>Free</span>"
    end

    if prices.any? {|price| price.name == "$"}
      prices_string += "<span data-toggle='tooltip' title data-original-title='Inexpensive' class='green-font price'>$</span>"
    else
      prices_string += "<span data-toggle='tooltip' title data-original-title='Inexpensive' class='grey-font price'>$</span>"
    end

    if prices.any? {|price| price.name == "$$"}
      prices_string += "<span data-toggle='tooltip' title data-original-title='Midrange' class='green-font price'>$$</span>"
    else
      prices_string += "<span data-toggle='tooltip' title data-original-title='Midrange' class='grey-font price'>$$</span>"
    end

    if prices.any? {|price| price.name == "$$$"}
      prices_string += "<span data-toggle='tooltip' title data-original-title='Expensive' class='green-font price'>$$$</span>"
    else
      prices_string += "<span data-toggle='tooltip' title data-original-title='Expensive' class='grey-font price'>$$$</span>"
    end

    prices_string

  end

  def draw_accessibilty_icons(category)
    if category.identifier == "hearing-impaired"
      "<i data-toggle='tooltip' title data-original-title='Hearing impaired' class='fa fa-deaf accessibility'></i>"
    elsif category.identifier == "wheelchair-access"
      "<i data-toggle='tooltip' title data-original-title='Wheelchair access' class='fa fa-wheelchair accessibility'></i>"
    elsif category.identifier == "children-with-special-needs"
      "<i data-toggle='tooltip' title data-original-title='Children with special needs' class='fa fa-child accessibility'></i>"
    elsif category.identifier == "sight-impaired"
      "<i data-toggle='tooltip' title data-original-title='Sight impaired' class='fa fa-braille accessibility'></i>"
    end
  end

  def draw_fun_fact_photo(funfact, place)
    if funfact.hero_photo_url.blank?
      showing_image(get_random_place_photo(place))
    else
      funfact.hero_photo_url
    end
  end

  def draw_rating_smiles(place)
    count = "0"
    rates_total = "<span class='rate-count grey-font'>( " + count + " )</span>"

    if !@place.quality_average.blank?
      count = place.quality_rates.size.to_s
      rates_total = "<span class='rate-count grey-font'>( " + count + " )</span>"
      orange = ""
      grey = ""
      rating = place.quality_average.avg.round
      remainder = 5 - place.quality_average.avg.round
      rating.times do
        orange += "<i class='fa fa-smile-o'></i>"
      end

      remainder.times do
        grey += "<i class='fa fa-smile-o'></i>"
      end

      solution = "<span class='orange-icon'>" + orange + "</span>" + "<span class='grey-icon'>" + grey + "</span>" + rates_total

    else
      if user_signed_in?
        solution = '<a href="javascript:void(0)"><span style="font-size:18px;" class="message-text" data-toggle="modal" data-target="#ReviewModal">LEAVE A REVIEW</span></a>'
      else
        solution = '<a href="javascript:void(0)"><span style="font-size:18px;" class="message-text" data-toggle="modal" data-target="#myModal">LEAVE A REVIEW</span></a>'
      end
    end
  end

  def draw_smile_review(review)
    rate = Rate.find_by_rater_id_and_rateable_id(review.user.id, review.reviewable.id)
    if rate
      orange = ""
      grey = ""
      rating = rate.stars.round
      remainder = 5 - rate.stars.round

      rating.times do
        orange += "<i class='fa fa-smile-o'></i>"
      end

      remainder.times do
        grey += "<i class='fa fa-smile-o'></i>"
      end

      solution = "<span class='orange-icon'>" + orange + "</span>" + "<span class='grey-icon'>" + grey + "</span>"

    else

      solution = ""
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    devise_mapping.to
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

  def user_generated_content_credit(user)
    ''
  end

  def place_or_country_link(place)
    begin
      if place.class.to_s == "Place"
        link_to place.display_name, place_path(place)
      elsif place.class.to_s == "Country"
        link_to place.display_name, country_path(place)
      end
    rescue
      ""
    end
  end

  def full_title(page_title = '', category='')
    base_title = "Bound Round"
    if category.empty?
      if page_title.empty?
        "Activities, Reviews and Things To Do For Kids: " + base_title
        #base_title + " | Fun Travel and Activities for Kids"
      else
        "#{page_title} For Kids: Activities and Reviews"
      end
    else
      if category.eql?("beach")
        page_title+" : Things To Do for Kids"
      elsif  category.eql?("sports")
        page_title+" : Institute of Sport things To Do : Bound Round"
      elsif  ["place_to_eat", "place_to_stay"].include?(category)
        page_title+" : For Kids : Bound Round"
      elsif  category.eql?("transport")
        page_title+" : Cableway Things To Do : Bound Round"
      elsif  category.eql?("area")
        page_title+" : Things To Do By Kids For Kids : Bound Round"
      else
        page_title + " Things To Do : Bound Round"
      end
    end
  end

  def body_title(title= '', category='')
    if category.empty?
      if title.empty?
        "Activities, Reviews and Things To Do For Kids: Bound Round"
      else
        title+" : Activities for Kids"
      end
    else
      if category.eql?("beach")
        title+" : Activities and Reviews"
      else
        title
      end
    end
  end

  def meta_description(title='', description='')
    if title.blank? && description.blank?
      "Find things for kids to do, reviews and activies to do in destinations around the world, see videos and share stories to earn points and redeem them for great rewards."
    elsif title.blank?
      "#{description}"
    elsif description.blank?
      "#{title} - Find things for kids to do, reviews and activies to do in destinations around the world, see videos and share stories to earn points and redeem them for great rewards."
    else
      "#{title} - #{description}"
    end
  end

  def draw_hero_background(place)
    if place.class.to_s == "Country"
      if place.photos.find_by country_hero: true
        place.photos.find_by(country_hero: true).path_url(:large)
      else
        asset_path('generic-hero.jpg')
      end
    else
      if place.photos.find_by(hero: true)
        place.photos.find_by(hero: true).path_url(:large)
      elsif place.user_photos.find_by(hero: true)
        place.user_photos.find_by(hero: true).path_url(:large)
      else
        asset_path('generic-hero.jpg')
      end
    end
  end

  def draw_small_background(place)
    if place.photos.find_by(hero: true)
      place.photos.find_by(hero: true).path_url(:small)
    elsif place.user_photos.find_by(hero: true)
      place.user_photos.find_by(hero: true).path_url(:small)
    else
      asset_path('generic-hero-small.jpg')
    end
  end

  def draw_medium_background(place)
    if place.photos.find_by(hero: true)
      place.photos.find_by(hero: true).path_url(:medium)
    elsif place.user_photos.find_by(hero: true)
      place.user_photos.find_by(hero: true).path_url(:medium)
    else
      asset_path('generic-hero-small.jpg')
    end
  end

  def open_graph_image
      placeholder = "https://blooming-earth-8066-herokuapp-com.global.ssl.fastly.net/assets/br_logo_new-30eb3b9bb0267503159d6cab93191844.png"

      if @place && !@place.photos.blank?
        photo = @place.photos.first.path_url :large
      elsif @country && !@country.photos.blank?
        photo = @country.photos.first.path_url :large
      end

      if photo.present?
        photo
      else
        placeholder
      end
  end

  def get_random_place_photo(place)
    if place.photos.length > 0
      photo = place.photos[rand(0...place.photos.length)]
      if photo
        photo.path_url(:small)
      end
    else
      asset_path('generic-hero-small.jpg')
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
    case place.primary_category.identifier
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
      when 'transport'
        '#127fff'
      else
        '#f2a1bc'
    end
  end

  def like_icon(content)
    postPath = content.class.to_s.pluralize.downcase + '_' + 'users'
    postType = postPath.singularize
    postType = 'fun_facts_user' if postType == 'funfacts_user'
    postPath = 'fun_facts_users' if postPath == 'funfacts_users'
    postType = 'user_photos_user' if postType == 'userphotos_user'
    postPath = 'user_photos_users' if postPath == 'userphotos_users'

    if user_signed_in?
      if content.users.include?(current_user)
        return "<a class='like-icon' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='true'><i class='fa fa-heart liked-heart'></i></a>"
      else
        return "<a class='like-icon' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='false'><i class='fa fa-heart-o like-heart'></i></a>"
      end
    end
      "<a class='like-icon'><i class='fa fa-heart-o like-heart'></i></a>"
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

  def strip_domain_from_username(user)
    begin
      if user.username.match(/@/)
        user.username.match(/^(.*?)@/)[1]
      else
        user.username
      end
    rescue
      ""
    end
  end

  def get_user_place_rating_from_review(review)
    if Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id).length > 0
      Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id)[0].stars.round
    else
      0
    end
  end

  def calculate_user_points_for_asset(asset_collection)
    begin
      value = PointsValue.find_by(asset_type: asset_collection.first.class.to_s).value
      value * asset_collection.length
    rescue
      0
    end
  end

  def is_flash_key_for_tracking?(key)
    [
     "recently_signed_in", "recently_signed_out",
     "recently_signed_in_with_instagram", "recently_failed_signed_in_with_instagram"
    ].include?(key)
  end

  def showing_image(url)
    #return asset_path('generic-hero.jpg') if url.blank?
    return 'generic-hero.jpg' if url.blank?
    url
  end

  def deal_image(url)

    return draw_hero_background(@place) if url.blank?

    url
  end

  def remote_file_exists?(url)
    response = HTTParty.get(url)
    response.code == 200 && response.headers['Content-Type'].start_with?('image')
  end

  def last_page? collection
    collection.total_pages == collection.current_page
  end

  def algolia_raw_last_page? collection
    ( (collection['nbPages'].to_i - 1) == collection['page']) or collection.traverse('hits').blank?
  end

  def algolia_raw_next_page collection
    collection.traverse('page').to_i + 1
  end


end
