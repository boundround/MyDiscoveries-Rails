class Attraction < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, :use => :slugged #show display_names in place routes

  # attribute :primary_category do
  #   if self.primary_category
  #     { name: "#{primary_category.name}", identifier: primary_category.identifier}
  #   else
  #     ""
  #   end
  # end

  # attribute :result_type do
  #   if self.is_area == true
  #     "Destination"
  #   else
  #     if self.primary_category.blank?
  #       "Something To Do"
  #     else
  #       self.primary_category.name
  #     end
  #   end
  # end

  # attribute :main_category do
  #   primary_category.name if primary_category.present?
  # end

  scope :active, -> { where(status: "live") }

  belongs_to :country
  belongs_to :user
  belongs_to :primary_category

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

  has_many :good_to_knows, as: :good_to_knowable
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :photos, -> { order "created_at ASC"}
  has_many :videos, -> { order "created_at ASC"}
  has_many :reviews, as: :reviewable
  has_many :deals, as: :dealable
  has_many :user_photos

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

end
