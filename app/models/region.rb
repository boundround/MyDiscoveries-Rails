class Region < ActiveRecord::Base
  include AlgoliaSearch
  include Searchable

  attr_accessor :run_rake, :no_parent_select

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :history]

  algoliasearch index_name: "mydiscoveries_#{Rails.env}", id: :algolia_id do
    # list of attribute used to build an Algolia record
    attributes :display_name,
               :slug,
               :description,
               :latitude,
               :longitude,
               :zoom_level

    synonyms [
      ["active", "water sports", "sports", "sport", "adventurous", "adventure", "snow", "beach", "camping"],
      ["disabled", "wheelchair access", "accessible"]
    ]

    attribute :description do
      description.blank? ? "" : description
    end

    attribute :photos do
      ""
    end

    attribute :viator_link do
      ""
    end

    attribute :is_country do
      false
    end

    attribute :is_area do
      false
    end

    attribute :hero_photo do
      hero_h = photos.where(photos: { hero: true })
      hero_h = hero_h.first
      hero= {}
      if hero_h.present?
        hero= { url: hero_h.path_url(:medium), alt_tag: hero_h.caption }
      else
        hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
      end
      hero
    end

    attribute :has_hero_image do
      photos.exists?(hero: true)
    end

    attribute :parents do
      self.get_parents(self).map {|region| region.ame rescue ''} unless !self.run_rake.blank? || (no_parent_select.eql? "true")
    end

    attribute :result_type do
      "Region"
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :viator_link do
      ""
    end

    attribute :url do
      Rails.application.routes.url_helpers.region_path(self)
    end

    attribute :where_destinations do
      'Region' if self.class.to_s == 'Region'
    end

    attributesToIndex [
      'display_name',
      'unordered(description)',
      'tags',
      'age_range',
      'accessible',
      'subcategories',
      'unordered(parents)',
      'unordered(display_address)',
      'unordered(primary_category)',
      'publish_date',
      'item_id',
      'child_item_id',
      'related_item_id',
      'tags',
      'places_visited'
    ]

    customRanking Searchable.custom_ranking

    attributesForFaceting [
      'where_destinations',
      'is_area',
      'main_category',
      'age_range',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility',
      'places_visited'
    ]
  end

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :regions_users
  has_many :users, through: :regions_users

  has_many :regions_stories
  has_many :stories, through: :regions_stories

  has_many :offers_regions
  has_many :offers, through: :offers_regions

  has_many :products_regions, class_name: Spree::ProductsRegion, dependent: :destroy
  has_many :products, through: :products_regions, class_name: Spree::Product

  has_many :fun_facts, -> { order "created_at ASC"}, as: :fun_factable
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable

  has_and_belongs_to_many :places

  mount_uploader :hero_photo, RegionPhotoUploader

  accepts_nested_attributes_for :parent, :allow_destroy => true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true
  before_save :fill_places


  def get_parents(region, parents = [])
    unless !self.run_rake.blank? || (no_parent_select.eql? "true")
      if region.parent.blank?
        return parents
      else
        unless region.parent.parentable_id == self.id
          parents << region.parent.parentable
          get_parents(region.parent.parentable, parents)
        end
      end
    end
  end

  def slug_candidates
    :display_name
  end

  def should_generate_new_friendly_id?
    slug.blank? || display_name_changed?
  end

  def children
    Rails.cache.fetch([self, "children"]) do
      list = childrens.select {|child| child.itemable.present?}
      list = list.map { |child| child.itemable }
      return list
    end
  end

  def get_places
    places_list = []
    queue = self.children

    while !queue.empty?
    place = queue.shift
      if place.class.to_s == "Place" && place.status == "live"
        places_list << place
      end
      place.children.each do |child|
        queue << child
      end
    end
    places_list
  end

  def get_attractions

  end

  def fill_places
    self.places = []
    self.places = self.get_places
  end

  def fill_attractions

  end

  def all_place_children
    children_collect = self.places
    data_marker = []
    if children_collect.present?
      children_collect.each do |place|
        hero_photo = place.photos.where(hero: true)
        data_objs = {
          "#place" => place.display_name,
          "#lat" => place.latitude,
          "#lng" => place.longitude,
          "#description" => place.description,
          "#country" => place.country.present?? place.country.display_name : "",
          "#path" => place_path(place),
          "#photo" => hero_photo.present?? hero_photo.last.path_url(:thumb) : "/assets/generic-hero-thumb.jpg",
          "#offer" => []
        }

        if place.products.blank?
          data_offer_objs = {
            "@country" => place.country.present?? place.country.display_name : "",
            "@name" => "Products is empty!",
            "@photo_offer" => "/assets/generic-hero-thumb.jpg"
          }
          data_objs["#offer"] << data_offer_objs
          data_objs["#offer"] << ["#"]
        else
          place.products.each do |place_offer|
            # latitude  = place_offer.latitudeStart.blank? ? place_offer.latitudeEnd.to_f : place_offer.latitudeStart.to_f
            # longitude = place_offer.longitudeStart.blank? ? place_offer.longitudeEnd.to_f : place_offer.longitudeStart.to_f
            # get_country = 'No Country'
            # if (latitude and longitude)
            #   geo_localization = "#{latitude},#{longitude}"
            #   query = Geocoder.search(geo_localization).first
            #   get_country = query.country
            # end
            hero_photo_offer = place_offer.photos.where(hero: true)
            data_offer_objs = {
              "@country" => place.country.present?? place.country.display_name : "",
              "@name" => place_offer.name,
              "@photo_offer" => hero_photo_offer.present?? hero_photo_offer.last.path_url(:thumb) : "/assets/generic-hero-thumb.jpg"
            }
            data_objs["#offer"] << data_offer_objs
            data_objs["#offer"] << ["#"]
          end
        end

        data_marker << data_objs
        data_marker << ["@"]
      end

      return data_marker
    else
      hero_photo = self.photos.where(hero: true)
      data_objs = {
        "#place" => self.display_name,
        "#lat" => self.latitude.to_f,
        "#lng" => self.longitude.to_f,
        "#description" => self.description,
        "#country" => "",
        "#path" => region_path(self),
        "#photo" => hero_photo.present?? hero_photo.last.path_url(:thumb) : "/assets/generic-hero-thumb.jpg",
        "#offer" => []
      }

      data_offer_objs = {
        "@country" => "Country",
        "@name" => "Products is empty!",
        "@photo_offer" => "/assets/generic-hero-thumb.jpg"
      }
      data_objs["#offer"] << data_offer_objs
      data_objs["#offer"] << ["#"]

      data_marker << data_objs
      data_marker << ["@"]
      
      return data_marker
    end
  end

  private

  def algolia_id
    "region_#{id}" # ensure the attraction & country IDs are not conflicting
  end

end
