module ApplicationHelper
  
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

  def price_text(offer)
    payment = ""
    if offer.minRateAdult
      payment = number_to_currency(offer.minRateAdult / 5.0)
    else
      ""
    end
    if offer.allow_installments
      "Only #{payment} / month for 5 months or #{offer.minRateAdult} upfront."
    else
      "#{offer.minRateAdult}"
    end
    # Only $299 / month for 5 months or $1,495 upfront.
  end

  def offer_minimum_price(offer)
    prices = []
    
    if offer.variants.blank?
      return 0
    end

    offer.variants.each do |variant|
      if variant.featured?
        return variant.price.to_f
      end
      if variant.maturity.present? && variant.maturity.downcase.strip != "child"
        prices << variant.price.to_f
      end
    end
    prices.min
  end

  def draw_fun_fact_photo(funfact, place)
    if funfact.hero_photo_url.blank?
      showing_image(get_random_place_photo(place))
    else
      funfact.hero_photo_url
    end
  end

  def draw_country_partial_photo(partial_part, place)
    if partial_part.photo.blank?
      showing_image(get_random_place_photo(place))
    else
      partial_part.photo.url
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
    base_title = "MyDiscoveries"
    if category.empty?
      if page_title.empty?
        "MyDiscoveries: make one day today. Where over 50s can find holidays experiences they've always wanted to do"
        # "Activities, Reviews and Things To Do For Kids: " + base_title
        #base_title + " | Fun Travel and Activities for Kids"
      else
        "MyDiscoveries - #{page_title}"
      end
    else
      if category.eql?("beach")
        page_title+" : Things To Do for Kids"
      elsif  category.eql?("sports")
        page_title+" : Institute of Sport things To Do : MyDiscoveries"
      elsif  ["place_to_eat", "place_to_stay"].include?(category)
        page_title+" : For Kids : MyDiscoveries"
      elsif  category.eql?("transport")
        page_title+" : Cableway Things To Do : MyDiscoveries"
      elsif  category.eql?("area")
        page_title+" : Things To Do : MyDiscoveries"
      else
        page_title + " Things To Do : MyDiscoveries"
      end
    end
  end

  def body_title(title= '', category='')
    "MyDiscoveries: make one day today. Where over 50s can find holidays experiences they've always wanted to do"
  end

  def meta_description(title='', description='')
    "MyDiscoveries: make one day today. Where over 50s can find holidays experiences they've always wanted to do"
  end

  def draw_hero_background(place)
    if place.photos.find_by(hero: true)
      place.photos.where(hero: true).last.path_url(:medium)
    elsif place.class.to_s == "Place" && place.user_photos.find_by(hero: true)
      place.user_photos.find_by(hero: true).path_url(:medium)
    else
      asset_path('generic-hero.jpg')
    end
  end

  def draw_hero_background_region(region)
    if region.photos.find_by(hero: true)
      region.photos.find_by(hero: true).path_url(:medium)
    else
      asset_path('generic-hero.jpg')
    end
  end

  def get_hero_image_credit(entity)
    hero_credit =
      entity.try(:photos).try(:find_by, { country_hero: true }).try(:credit) ||
      entity.try(:user_photos).try(:find_by, { hero: true }).try(:credit)

    if hero_credit
      "Credit: #{hero_credit}"
    else
      ""
    end
  end

  def draw_small_background(place)
    if place.photos.find_by(hero: true)
      place.photos.find_by(hero: true).path_url(:small)
    elsif place.class.to_s == "Place" && place.user_photos.find_by(hero: true)
      place.user_photos.find_by(hero: true).path_url(:small)
    else
      asset_path('generic-hero-small.jpg')
    end
  end

  def draw_medium_background(place)
    if place.photos.find_by(hero: true)
      place.photos.find_by(hero: true).path_url(:medium)
    elsif place.class.to_s == "Place" && place.user_photos.find_by(hero: true)
      place.user_photos.find_by(hero: true).path_url(:medium)
    else
      asset_path('generic-hero-small.jpg')
    end
  end

  def open_graph_image
    placeholder = "https://s3-ap-southeast-2.amazonaws.com/mydiscoveries/logos/logo-full.svg"

    if @place && !@place.photos.blank?
      photo = @place.photos.first.path_url :large
    elsif @country && !@country.photos.blank?
      photo = @country.photos.first.path_url :large
    elsif @offer && !@offer.photos.blank?
      hero = @offer.photos.select{|p_hero| p_hero.hero.eql?(true) }
      photo = if hero.blank?
        @offer.photos.first.path_url :large
      else
        hero.first.path_url :large
      end
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

  def create_marker(map_marker)
    marker = []
    if map_marker.class.to_s == "Array"
      map_marker.each do |map|
        if map.present?
          # ['Sydney', 'description', 'telephone', 'email', 'web', -33.865079, 151.212088, '/assets/mydiscoveries_icon/i/map/map-point.png']
          marker.push([map.display_name||"", map.description||"",
                       map.phone_number||"", map.email||"", map.website||"", map.latitude||"", map.longitude||"",'/assets/mydiscoveries_icon/i/map/map-point.png'])
        end
      end
    else
      if map_marker.class.to_s == "Offer"
        marker.push([map_marker.name||"", map_marker.description||"",
                      "", "", "", map_marker.latitudeStart.to_f||"", map_marker.longitudeStart.to_f||"", '/assets/mydiscoveries_icon/i/map/map-point.png'])
      elsif map_marker.class.to_s == "Spree::Product"
        marker.push([map_marker.name||"", map_marker.description||"",
                      "", "", "", map_marker.latitudeStart.to_f||"", map_marker.longitudeStart.to_f||"", '/assets/mydiscoveries_icon/i/map/map-point.png'])
      else
        marker.push([map_marker.display_name||"", map_marker.description||"",
                       map_marker.phone_number||"", map_marker.email||"", map_marker.website||"", map_marker.latitude||"", map_marker.longitude||"", '/assets/mydiscoveries_icon/i/map/map-point.png'])
      end
    end
    marker
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
    else
      ""
    end
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

  def is_flash_key_for_tracking?(key)
    [
     "recently_signed_in", "recently_signed_out",
     "recently_signed_in_with_instagram", "recently_failed_signed_in_with_instagram"
    ].include?(key)
  end

  def showing_image(url)
    url.presence || asset_path('generic-hero.jpg')
  end

  def deal_image(url)
    variable = @place.blank? ? @attraction : @place

    return draw_hero_background(variable) if url.blank?

    url
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

  def destination_available(all_collection, collection)
    available = []
    if self.class.name == "RelatedOffersController"
      collections = []
      collection.each do |offer|
        id = offer.spree_related_product_id
        collections << Spree::Product.find(id) if id.present?
      end
      collection = collections
    end

    all_collection.each do |col|
      available << col unless collection.include? col
    end
    available
  end

  def create_duration(offer)
    text = ""
    text += offer.number_of_days.present?? pluralize(offer.number_of_days, "day") : ""
    text += offer.number_of_days.present? && offer.number_of_nights.present?? "/" : ""
    text += offer.number_of_nights.present?? pluralize(offer.number_of_nights, "night") : ""
  end

  def clean_text(datas)
    models_name = datas.class
    columns = models_name.column_names
    columns.each do |col|
      if (models_name.columns_hash[col].type == :text ||
          models_name.columns_hash[col].type == :string) &&
          datas[col].present?
        datas[col] = datas[col].gsub(/[”“’]/, "”" => "\"", "“" => "\"", "’" => "\'")
      end
    end
    datas
  end

  def shopping_cart_label(mobile=false)
    total_count = current_order.try(:line_items).try(:count)
    if total_count.to_i > 0
      if mobile
        " #{pluralize(total_count, 'item')} "
      else
        " #{pluralize(total_count, 'item')} - #{number_to_currency(current_order.total)} "
      end
    else
      ' Empty '
    end
  end

end
