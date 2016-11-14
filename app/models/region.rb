class Region < ActiveRecord::Base
  include AlgoliaSearch
  include Searchable

  attr_accessor :run_rake

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
      self.get_parents(self).map {|region| region.display_name rescue ''} unless !self.run_rake.blank?
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

    customRanking [
      'desc(is_country)',
      'desc(is_area)',
      'desc(primary_category_priority)',
      'desc(page_ranking_weight)',
      'desc(has_hero_image)',
    ]

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

  has_many :regions_stories
  has_many :stories, through: :regions_stories

  has_many :fun_facts, -> { order "created_at ASC"}, as: :fun_factable
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable

  accepts_nested_attributes_for :parent, :allow_destroy => true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true


  def get_parents(region, parents = [])
    unless !self.run_rake.blank?
      if region.parent.blank?
        return parents
      else
        parents << region.parent.parentable
        get_parents(region.parent.parentable, parents)
      end
    end
  end

  def slug_candidates
    g_parent = get_parents(self, parents = [])
    p_display_name = g_parent.collect{ |parent| parent.display_name }

    if p_display_name.blank?
      ["#{self.display_name}"]
    else
      primary_area_display_name = p_display_name.reverse.map {|str| str.downcase }.join(' ')
      ["#{primary_area_display_name} #{self.display_name}"]
    end
  end

  def should_generate_new_friendly_id?
    unless self.run_rake
      slug.blank? || display_name_changed? || self.parent.parentable_id_changed?
    end
  end

  private
  def algolia_id
    "region_#{id}" # ensure the attraction & country IDs are not conflicting
  end

end
