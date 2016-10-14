class Attraction < ActiveRecord::Base
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

  has_many :photos, -> { order "created_at ASC"}
  has_many :videos, -> { order "created_at ASC"}
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :programs, -> { order "created_at ASC"}
  has_many :user_photos
  
  has_many :good_to_knows, as: :good_to_knowable

  has_many :three_d_videos
  has_many :reviews, as: :reviewable
  has_many :deals, as: :dealable
  has_many :stamps

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
      # row.each do |key, value|
      #   if key != "id"
      #     if value == 1
      #       attractions_subcategory = PlacesSubcategory.find_or_create_by(attraction_id: row["id"], subcategory_id: key)
      #     end
      #   end
      # end
    end
  end

  def trip_advisor_info
    body = nil
    trip_advisor_id = nil
    if trip_advisor_url.present?
      trip_advisor_id = trip_advisor_url.match(/(.*)(d[0-9]+)(.*)/)[2].gsub("d", "")
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

  def get_parents(attraction, parents = [])
    if attraction.parent.blank?
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
  
  def slug_candidates
    country = self.country
    g_parent = get_parents(self, parents = [])
    p_display_name = g_parent.collect{ |parent| parent.display_name }

    unless p_display_name.blank?
      primary_area_display_name = p_display_name.reverse.map {|str| str.downcase }.join(' ')
    end
    if is_area == true
      "things to do with kids and families #{country.display_name rescue ""} #{self.display_name}"
    else
      [ 
        "things to do with kids and families #{primary_area_display_name rescue ""} #{self.display_name}",
        ["things to do with kids and families #{primary_area_display_name rescue ""} #{self.display_name}", :post_code]
      ]
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || display_name_changed? || self.country_id_changed? || self.parent.parentable_id_changed?
  end


end
