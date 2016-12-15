class Region < ActiveRecord::Base
  include AlgoliaSearch
  include Searchable

  attr_accessor :run_rake, :no_parent_select

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :history]

  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id do
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
      self.get_parents(self).map {|region| region.display_name rescue ''} unless !self.run_rake.blank? || (no_parent_select.eql? "true")
    end

    attribute :result_type do
      "Region"
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :url do
      Rails.application.routes.url_helpers.region_path(self)
    end

    attribute :display_address do
      description.blank? ? "Bound Round Story" : description
    end

    attribute :where_destinations do
      'Region' if self.class.to_s == 'Region'
    end

    # attributesToIndex ['display_name', 'unordered(description)']
    attributesToIndex [
      'display_name',
      'unordered(description)',
      'age_range',
      'accessible',
      'subcategories',
      'unordered(parents)',
      'unordered(display_address)',
      'unordered(primary_category)',
      'publish_date',
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
    ]
  end

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :regions_users
  has_many :users, through: :regions_users

  has_many :regions_stories
  has_many :stories, through: :regions_stories

  has_many :fun_facts, -> { order "created_at ASC"}, as: :fun_factable
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable

  mount_uploader :hero_photo, RegionPhotoUploader

  accepts_nested_attributes_for :parent, :allow_destroy => true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true
  # after_create :update_parentable_id

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
    unless no_parent_select.eql? "true"
      g_parent = get_parents(self, parents = [])
      p_display_name = g_parent.collect{ |parent| parent.display_name }

      if p_display_name.blank?
        ["#{self.display_name}"]
      else
        primary_area_display_name = p_display_name.reverse.map {|str| str.downcase }.join(' ')
        ["#{primary_area_display_name} #{self.display_name}"]
      end
    end
  end

  def should_generate_new_friendly_id?
    unless self.run_rake || (no_parent_select.eql? "true")
      slug.blank? || display_name_changed? || self.parent.parentable_id_changed?
    end
  end

  def children
    Rails.cache.fetch([self, "children"]) do
      list = childrens.select {|child| child.itemable.present?}
      list = list.map { |child| child.itemable }
    end
  end

  def places
    Rails.cache.fetch([self, "places"]) do
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
  end

  def attractions
    Rails.cache.fetch([self, "attractions"]) do
      places_list = []
      queue = self.children

      while !queue.empty?
      place = queue.shift
        if place.class.to_s == "Attraction" && place.status == "live"
          places_list << place
        end
        place.children.each do |child|
          queue << child
        end
      end
      places_list
    end
  end

  def all_place_children
    Rails.cache.fetch([self, "all_place_children"]) do
      childrens_collect = self.places
      data_marker = []
      if !childrens_collect.blank?
        childrens_collect.each do |place|
          data_objs = {}
          data_objs['#place'] = place.display_name
          data_objs['#lat'] = place.latitude
          data_objs['#lng'] = place.longitude
          data_objs['#description'] = place.description
          data_objs['#country'] = place.country.display_name rescue ""
          data_objs['#path'] = place_path(place)
          if !place.photos.blank?
            data_objs['#photo'] = place.photos.last.path_url(:thumb)
          else
            data_objs['#photo'] = "/assets/generic-hero-thumb.jpg"
          end

          data_objs['#childrens'] = []
          place.attractions.each do |place_child|
              place_item_child = place_child
              data_child_objs = {}
              data_child_objs['@country_child'] = place_item_child.country.display_name rescue ""
              data_child_objs['@name_child'] = place_item_child.display_name
              if !place_item_child.photos.blank?
                data_child_objs['@photo_child'] = place_item_child.photos.last.path_url(:thumb)
              else
                data_child_objs['@photo_child'] = "/assets/generic-hero-thumb.jpg"
              end
              data_objs['#childrens'] << data_child_objs
              data_objs['#childrens'] << ["#"]
          end
          data_marker << data_objs
          data_marker << ["@"]
        end
        return data_marker
      else
        data_objs = {}
        data_objs['#place'] = self.display_name
        data_objs['#lat'] = self.latitude.to_f
        data_objs['#lng'] = self.longitude.to_f
        data_objs['#description'] = self.description
        data_objs['#country'] = ''
        data_objs['#path'] = place_path(self)
        if !self.photos.blank?
          data_objs['#photo'] = self.photos.last.path_url(:thumb)
        else
          data_objs['#photo'] = "/assets/generic-hero-thumb.jpg"
        end
        data_objs['#childrens'] = []
      end
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
