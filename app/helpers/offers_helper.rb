module OffersHelper
  def main_offer_photo_url(offer)
    photo = offer.photos.where(hero: true).first.presence || offer.photos.first.presence
    url   = photo.try(:path_url, :medium) || ActionController::Base.helpers.asset_path('generic-hero.jpg')
    title = photo.try(:title)

    { url: url, title: title }
  end

  # converts duration from microseconds to days
  def duration_in_days(duration)
    duration / (1.day * 1000)
  end

  def array_places_offers_ids(places_offers)
    place_ids = []
    places_offers.each do |places_offer|
      if !places_offer.place_id.blank?
        place = Place.find(places_offer.place_id)
        place_ids.push({place_id: place.id, place_name: place.display_name})
      end
    end
    place_ids.to_json
  end

  def array_attractions_offers_ids(attractions_offers)
    attraction_ids = []
    attractions_offers.each do |attractions_offer|
      if !attractions_offer.attraction_id.blank?
        attraction = Attraction.find(attractions_offer.attraction_id)
        attraction_ids.push({attraction_id: attraction.id, attraction_name: attraction.display_name})
      end
    end

    attraction_ids.to_json
  end

  def array_countries_offers_ids(countries_offers)
    country_ids = []
    countries_offers.each do |countries_offer|
      if !countries_offer.country_id.blank?
        country = Country.find(countries_offer.country_id)
        country_ids.push({country_id: country.id, country_name: country.display_name})
      end
    end
    country_ids.to_json
  end

  def array_regions_offers_ids(regions_offers)
    region_ids = []
    regions_offers.each do |regions_offer|
      if !regions_offer.region_id.blank?
        region = Region.find(regions_offer.region_id)
        region_ids.push({region_id: region.id, region_name: region.display_name})
      end
    end
    region_ids.to_json
  end

  def array_stories_products_ids(stories_products)
    story_ids = []
    stories_products.each do |stories_product|
      if !stories_product.region_id.blank?
        story = Story.find(stories_product.story_id)
        story_ids.push({story_id: story.id, story_name: story.display_name})
      end
    end
    story_ids.to_json
  end

  def create_breadcrumb_offer(offer)
    breadcrumb = ""
    if offer.place.present?
      place = offer.place

      parents = place.get_parents(place)

      parents.delete_if {|parent| parent.status != "live"}

      if !parents.blank?
        parents.reverse_each do |parent|
          if parent.class.to_s == "Place"
            breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", place_path(parent), class: "breadcrumbs__link"
          elsif parent.class.to_s == "Country"
            breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", country_path(parent), class: "breadcrumbs__link"
          elsif parent.class.to_s == "Attraction"
            breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", attraction_path(parent), class: "breadcrumbs__link"
          elsif parent.class.to_s == "Region"
            breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", region_path(parent), class: "breadcrumbs__link"
          end
        end
      end
      breadcrumb += link_to "#{place.display_name.upcase rescue ''}", place_path(place), class: "breadcrumbs__link"
    end

    breadcrumb += "<span class='breadcrumbs__link'>" + offer.name.upcase + "</span>"
  end

  def price_range(offer)
    prices = offer.variants.map{ |v| v.price }.sort
    prices = prices.blank? ? [0] : prices
    "$#{sprintf("%.2f", prices.first)} - $#{sprintf("%.2f", prices.last)}"
  end

  def voucher_total_paid(quantity, price)
    total_paid = "$#{sprintf("%.2f", (quantity * price))}"
  end

  def all_offer_photos(offer)
    photo_h = Hash.new
    unless offer.photos.blank? 
      offer.photos.active.where("hero = false or hero is null").uniq.each_with_index do |photo, idx|
        if idx < 4
          photo_h[idx] = {url: photo.path_url, id: photo.id}
        end
      end
    end

    return photo_h
  end

  def offer_includes(offer)
    @inc_exc = Hash.new
    
    str = offer.includes.split('EXCLUSIONS')
    str = offer.includes.split('EXCLUDES') if str.size.eql?(1)

    @inc_exc['includes'] = str.first
    @inc_exc['excludes'] = "</b><b>#{str.size.eql?(1) ? 'EXCLUSIONS' : 'EXCLUDES'}" + str.last

    return @inc_exc
  end

  def offer_departure_dates(offer)
    data = Hash.new

    offer.departure_dates.group_by do |dtd|
      split = dtd.split('/')
      new_dtd = split[2]+'-'+split[0]+'-'+split[1]
      test =  new_dtd.to_date.strftime('%d/%b/%Y').split('/')
      
      all_key = data.map{|k| k[0]}
      if all_key.include?("#{test[1]+'-'+test[2]}")
        data["#{test[1]+'-'+test[2]}"] << ", #{test[0]}"
      else
        data["#{test[1]+'-'+test[2]}"] = test[0]
      end
    end

    return data
  end

end
