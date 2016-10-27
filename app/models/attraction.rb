class Attraction < ActiveRecord::Base
  include Parameterizable
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :run_rake

  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :display_name,
               :status,
               :latitude,
               :longitude,
               :locality,
               :post_code,
               :display_address,
               :identifier,
               :slug,
               :minimum_age,
               :maximum_age,
               :viator_link,
               :primary_category_priority,
               :is_area,
               :page_ranking_weight

    synonyms [
        ["active", "water sports", "sports", "sport", "watersports"],
        ["disabled", "wheelchair access", "accessible"],
        ["culture", "cultural", "museum", "indigenous", "gallery", "galleries", "museums", "historic", "history"],
        ["science", "technology"],
        ["things to do", "something to do", "stuff to do", "activity", "activities"],
        ["year old", "ages", "year"],
        ["6", "7", "5-8"],
        ["10", "11", "9-12"],
        ["teenager", "teens", "teenagers"]
      ]

    attribute :country do
      if self.country
        "#{country.display_name}"
      else
        ""
      end
    end

    attribute :url do
      Rails.application.routes.url_helpers.attraction_path(self)
    end

    attribute :description do
      description.blank? ? "" : description
    end

    attribute :primary_category do
       if self.primary_category
        { name: "#{primary_category.name}", identifier: primary_category.identifier}
      else
        ""
      end
    end

    attribute :result_type do
      if self.primary_category.blank?
        "Something To Do"
      else
        self.primary_category.name
      end
    end

    attribute :is_country do
      false
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :main_category do
      primary_category.name if primary_category.present?
    end

    attribute :subcategories do
      subcategories.map{ |sub| { name: sub.name, identifier: sub.identifier } }
    end

    attribute :subcategory do
      subcategories.subcats.map{|sub| sub.name}
    end

    attribute :name do
      string = "#{display_name}"
      if !locality.blank?
        string += ", #{locality}"
      end
      if country
        string += ", #{self.country.display_name}"
      end
      string
    end

    attribute :photos do
      photo_array = photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.alt_tag }
      end
      photo_array += user_photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.caption }
      end
      photo_array
    end

    attribute :hero_photo do
      hero_h = photos.where(photos: { hero: true })
      hero_h += user_photos.where(user_photos: { hero: true })
      hero_h = hero_h.first
      hero= {}
      if hero_h.present?
        hero= { url: hero_h.path_url(:small), alt_tag: hero_h.caption }
      else
        hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
      end
      hero
    end

    attribute :has_hero_image do
      photos.exists?(hero: true) || user_photos.exists?(hero: true)
    end

    attribute :age_range do
      if minimum_age.present? and maximum_age.present?
        if minimum_age > 12
          ["Teens"]
        elsif minimum_age > 8 && maximum_age < 13
          ["For Ages 9-12"]
        elsif minimum_age > 8
          ["For Ages 9-12", "Teens"]
        elsif maximum_age < 13
          ["For Ages 5-8", "For Ages 9-12"]
        elsif maximum_age < 9
          ["For Ages 5-8"]
        else
          ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
        end
      else
        ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
      end
    end

    attribute :weather do
      subcategories.where(category_type: 'weather').map{ |sub|  sub.name }
    end

    attribute :price do
      subcategories.where(category_type: 'price').map{ |sub|  sub.name }
    end

    attribute :best_time_to_visit do
      subcategories.where(category_type: 'optimum_time').map{ |sub|  sub.name }
    end

    attribute :accessibility do
      subcategories.where(category_type: 'accessibility').map{ |sub|  sub.name }
    end

    attribute :parents do
      self.get_parents(self).map {|attraction| attraction.display_name rescue ''} unless !self.run_rake.blank?
    end

    attribute :accessible do
      if subcategories.any? { |sub| sub.category_type == "accessibility" }
        "accessible"
      else
        ""
      end
    end

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

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    customRanking [
      'desc(is_country)',
      'desc(is_area)',
      'desc(primary_category_priority)',
      'desc(page_ranking_weight)',
      'desc(has_hero_image)',
    ]

    attributesForFaceting [
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

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :history]

  scope :active, -> { where(status: "live") }

  belongs_to :country
  belongs_to :user
  belongs_to :primary_category

  # ratyrate_rateable "quality"
  has_many :rates_without_dimension, -> { where dimension: nil}, as: :rateable, class_name: 'Rate', dependent: :destroy
  has_many :raters_without_dimension, through: :rates_without_dimension, source: :rater

  has_one :rate_average_without_dimension, -> { where dimension: nil}, as: :cacheable,
          class_name: 'RatingCache', dependent: :destroy

  has_many "quality_rates".to_sym, -> {where dimension: "quality"},
                                              dependent: :destroy,
                                              class_name: 'Rate',
                                              as: :rateable

  has_many "quality_raters".to_sym, through: "quality_rates".to_sym, source: :rater

  has_one "quality_average".to_sym, -> { where dimension: "quality" },
                                              as: :cacheable,
                                              class_name: 'RatingCache',
                                              dependent: :destroy

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable
  has_many :children, :class_name => 'Attraction', :foreign_key => 'parent_id' # this relation actived for temporary

  has_many :attractions_users
  has_many :users, through: :attractions_users

  has_many :customers_attractions
  has_many :owners, through: :customers_attractions, :source => :user

  has_many :similar_attractions
  has_many :associated_areas, through: :similar_attractions, source: :similar_attraction

  has_many :attractions_subcategories
  has_many :subcategories, through: :attractions_subcategories

  has_many :attractions_posts
  has_many :posts, through: :attractions_posts

  has_many :attractions_stories
  has_many :stories, through: :attractions_stories

  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :programs, -> { order "created_at ASC"}
  has_many :user_photos
  has_many :stamps
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable
  has_many :three_d_videos, as: :three_d_videoable
  has_many :good_to_knows, as: :good_to_knowable
  has_many :reviews, as: :reviewable
  has_many :deals, as: :dealable

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :programs, allow_destroy: true
  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true
  accepts_nested_attributes_for :user_photos, allow_destroy: true
  accepts_nested_attributes_for :three_d_videos, allow_destroy: true
  accepts_nested_attributes_for :stamps, allow_destroy: true
  accepts_nested_attributes_for :parent, :allow_destroy => true

  def self.import_subcategories(file)
    attractions_subcategory = nil
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row = row.to_h
      row.each do |key, value|
        if key != "id"
          if value == 1
            attractions_subcategory = AttractionsSubcategory.find_or_create_by(attraction_id: row["id"], subcategory_id: key)
          end
        end
      end
    end
  end

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  def trip_advisor_info
    body = nil
    trip_advisor_id = nil
    if trip_advisor_url.present?
      unless trip_advisor_url.match(/(.*)(d[0-9]+)(.*)/).blank?
        trip_advisor_id = trip_advisor_url.match(/(.*)(d[0-9]+)(.*)/)[2].gsub("d", "")
      end
    end
    if trip_advisor_id
      response = HTTParty.get("http://api.tripadvisor.com/api/partner/2.0/location/#{trip_advisor_id}?key=6cd1112100c1424a9368e441f50cb642")
    else
      response = nil
    end

    if response.present?
      body = JSON.parse(response.body)
    end

    body
  end

  def self.import_update(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      attraction = Attraction.find row["id"]
      attraction.update!(row.to_h)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then CSV.new(file.path)
    when '.xls' then Roo::Spreadsheet.open(file.path, extension: :xls)
    when '.xlsx' then Roo::Spreadsheet.open(file.path, extension: :xlsx)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def all_subcategories
    all_subcategories = Hash.new
    self.subcategories.each do |subcat|
      if subcat.category_type.eql? 'duration'
        all_subcategories['duration'] = [subcat]
      elsif subcat.category_type.eql? 'optimum_time'
        all_subcategories['optimum_time'] = [subcat]
      elsif subcat.category_type.eql? 'accessibility'
        all_subcategories['accessibility'] = [subcat]
      elsif subcat.category_type.eql? 'price'
        all_subcategories['price'] = [subcat]
      end
    end

    return all_subcategories
  end

  def more_attractions
    another_field = (self.parent.blank?) ? "country_id = #{self.country_id}" : "status = 'live'"
    if self.primary_category.present? && self.primary_category.id == 2
      more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category_id: 1).where(another_field)
    else
      more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category: self.primary_category).where(another_field)
    end

    more_attractions = more_attractions.sort do |x, y|
      y.videos.size <=> x.videos.size
    end

    return more_attractions
  end

  def attraction_stories
    stories = self.posts.active
    stories += self.stories.active
    stories = stories.sort{|x, y| x.publish_date <=> y.publish_date}.reverse
  end

  def active_user_photos
    active_user_photos = self.user_photos.active
    photos = (self.photos.active + active_user_photos).sort {|x, y| x.created_at <=> y.created_at}

    return photos
  end

  def get_parents(attraction, parents = [])
    unless !self.run_rake.blank?
      if attraction.parent.blank? || attraction.parent.parentable == self
        if !attraction.country.blank?
          parents << attraction.country
          return parents
        else
          return parents
        end
      else
        parents << attraction.parent.parentable
        if attraction.parent.parentable.class.to_s.eql? "Country"
          parents << attraction.country
          return parents
        else
          get_parents(attraction.parent.parentable, parents)
        end
      end
    end
  end

  def slug_candidates
    country = self.country
    g_parent = get_parents(self, parents = [])
    p_display_name = g_parent.collect{ |parent| parent.display_name }

    if p_display_name.blank?
      ["things to do with kids and families #{self.display_name}", :post_code]
    else
      primary_area_display_name = p_display_name.reverse.map {|str| str.downcase }.join(' ')
      ["things to do with kids and families #{primary_area_display_name} #{self.display_name}", :post_code]
    end
  end

  def should_generate_new_friendly_id?
    unless self.run_rake
      slug.blank? || display_name_changed? || self.country_id_changed? || self.parent.parentable_id_changed?
    end
  end

  def meta_description
    meta_description
  end

  def content
    description
  end

  private
  def algolia_id
    "attraction_#{id}" # ensure the attraction & country IDs are not conflicting
  end

end
