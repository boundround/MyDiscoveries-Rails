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
end
