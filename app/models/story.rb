class Story < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable

  friendly_id :slug_candidates, :use => [:slugged, :history]
  # after_update :send_live_notification
  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :title,
               :status,
               :slug,
               :minimum_age,
               :maximum_age,
               :description,
               :primary_category_priority,
               :page_ranking_weight

    synonyms [
        ["active", "water sports", "sports", "sport", "adventurous", "adventure", "snow", "beach", "camping"],
        ["disabled", "wheelchair access", "accessible"]
      ]

    attribute :url do
      Rails.application.routes.url_helpers.story_path(self)
    end

    attribute :content do
      story_text
    end

    attribute :display_name do
      title
    end

    attribute :display_address do
      "Bound Round Story"
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

    attribute :primary_category do
       if self.primary_category
        { name: "#{primary_category.name}", identifier: primary_category.identifier}
      else
        ""
      end
    end

    attribute :result_type do
      "Story"
    end

    attribute :result_icon do
      "book"
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
      title
    end

    attribute :photos do
      ""
    end

    attribute :hero_photo do
      hero_h = photos.where(photos: { hero: true })
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
      photos.exists?(hero: true)
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

    attribute :where_destinations do
      'Stories' if self.class.to_s == 'Story'
    end

     #country and url

    # the attributesToIndex` setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute.
    # attributesToIndex ['display_name', 'unordered(content)', 'unordered(display_address)', 'primary_category', 'subcategories']
    attributesToIndex [
      'display_name',
      'unordered(description)',
      'age_range',
      'unordered(content)',
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

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    # customRanking ['desc(likes_count)']

    attributesForFaceting [
      'where_destinations',
      'is_area',
      'main_category',
      'age_range',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility'
    ]
  end

  belongs_to :user
  belongs_to :storiable, polymorphic: true

  has_many :stories_users
  has_many :users, through: :stories_users

  belongs_to :primary_category

  has_many :places_stories
  has_many :places, through: :places_stories

  has_many :attractions_stories
  has_many :attractions, through: :attractions_stories

  has_many :stories_subcategories
  has_many :subcategories, through: :stories_subcategories

  has_many :countries_stories
  has_many :countries, through: :countries_stories

  has_many :story_images, dependent: :destroy

  has_many :photos, -> { order "created_at ASC"}, as: :photoable

  scope :active, -> { where(status: "live").where(public: true) }
  scope :draft, -> { where(status: "draft") }
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  attr_accessor :age_bracket

  AGE_BRACKET= { toddlers: 5..8, kids: 9..12, teenagers: 13..19, adults: 20..50 }

  validates :title, presence: true
  validates :content, presence: true

  before_update :regenerate_slug
  before_save :determine_age_bracket, :check_null_publish_date, :populate_seo_friendly_url

  accepts_nested_attributes_for :photos, allow_destroy: true

  def send_live_notification
    places = []
    self.user.stories.user_already_notified_today.each do |story|
     places.push story.place
    end

    unless places.include?(self.place)
      if (self.status_changed? && self.status == "live" && self.status_was == "draft")
        if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
          LiveNotification.delay_until(Time.now.at_end_of_day).notification(self.place, self.user)
          self.user_notified = true
          self.user_notified_at = Time.now
          self.save
        end
      end
    end
  end

  def self.active
    where(status: "live").where('publish_date < ?', Date.today + 10.hours) #Sydney Time
  end

  def active
    (self.status == "live") && (publish_date < (Date.today + 10.hours))
  end

  def self.all_active_stories
    Rails.cache.fetch("all_stories", expires_in: 12.hours) do
      Story.active.includes(:user).order(publish_date: :desc).order(created_at: :desc)
    end
  end

  def story_title
    html_title = Nokogiri::HTML::Document.parse self.title

    title = html_title.at_css('h2').text rescue ""
  end

  def teaser
    teaser_text = content.scan(/<p.*?>.*?<\/p>/).map do |paragraph|
      '<p>' + Nokogiri::HTML(paragraph) + '</p>'
    end

    if teaser_text.present?
      teaser_text = teaser_text.reduce(:+)[0..180] + "..."
    else
      ""
    end
  end

  def story_text
    string = ""
    content = Nokogiri::HTML::Document.parse self.content
    content.css('p').each do |paragraph|
      string += paragraph
    end
    string
  end

  def description

    text = Nokogiri::HTML::Document.parse content
    desc = text.search("//text()").map(&:text)
    result = ""
    desc.each do |paragraph|
      if paragraph.size > 20
        result = paragraph
        break
      end
    end

    result

  end

  def published?
    if self.active
      true
    else
      false
    end
  end

  def hero_image
    hero_h = photos.where(photos: { hero: true })

    if hero_h.present?
      hero = hero_h.first
    else
      hero = story_images.first
    end

    hero
  end

  def hero_image_url
    if hero_image.present?
      if hero_image.is_a?(Photo)
        hero_image.path_url(:medium)
      else
        hero_image.url
      end
    else
      ""
    end
  end

  def check_null_publish_date
    if publish_date.blank?
      self.publish_date = Date.today
    end
  end

  def stories_like_this
    ids = [
      Story.joins(:subcategories).where(subcategories: { id: subcategories.pluck(:id) }).pluck(:id),
      Story.joins(:places).where(places: { id: places.pluck(:id) }).pluck(:id)
    ].reduce(:+).uniq
    Story.includes(:user).where(id: ids).order(:created_at)
  end

  def story_place_to_visit
    story_places = self.places
    story_places_parents = self.places.each {|place| place.get_parents(place) }
    places_to_visit = (story_places + story_places_parents).uniq.flatten.sort_by(&:display_name)

    return places_to_visit
  end

  protected

    def determine_age_bracket
      if age_bracket.present?
        self.minimum_age = AGE_BRACKET[age_bracket.to_sym].try(:first)
        self.maximum_age = AGE_BRACKET[age_bracket.to_sym].try(:last)
      end
    end

  private
    def algolia_id
      "story_#{id}" # ensure the place, post & country IDs are not conflicting
    end

    def slug_candidates
      if seo_friendly_url.present?
        :seo_friendly_url
      else
        :title
      end
    end

    def regenerate_slug
      if self.seo_friendly_url_changed?
        self.slug = seo_friendly_url.parameterize
      end
    end

    def populate_seo_friendly_url
      if self.seo_friendly_url.blank?
        if self.title.present?
          self.seo_friendly_url = self.title
        else
          self.seo_friendly_url = "bound-round-story-#{SecureRandom.hex(8)}"
        end
      end
    end

end
