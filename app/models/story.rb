class Story < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch

  mount_base64_uploader :hero_image, StoryHeroImageUploader
  friendly_id :slug_candidates, :use => :slugged
  # after_update :send_live_notification
  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :status, :slug, :minimum_age, :maximum_age, :description

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
      story_title
    end

    attribute :title do
      story_title
    end

    attribute :display_address do
      "Bound Round Story"
    end

    attribute :viator_link do
      ""
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
      if hero_image.blank? || hero_image_url.blank?
        { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage" }
      else
        { url: hero_image_url, alt_tag: hero_image_url }
      end
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

     #country and url

    # the attributesToIndex` setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute.
    # attributesToIndex ['display_name', 'unordered(content)', 'unordered(display_address)', 'primary_category', 'subcategories']
    attributesToIndex ['display_name', 'age_range', 'unordered(content)','accessible', 'subcategories', 'unordered(parents)', 'unordered(description)', 'unordered(display_address)', 'unordered(primary_category)', 'publish_date']


    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    # customRanking ['desc(likes_count)']

    attributesForFaceting ['main_category', 'age_range', 'subcategory', 'weather', 'price', 'best_time_to_visit', 'accessibility']
  end

  belongs_to :user
  belongs_to :storiable, polymorphic: true

  has_many :stories_users
  has_many :users, through: :stories_users

  belongs_to :primary_category

  has_many :places_stories
  has_many :places, through: :places_stories

  has_many :stories_subcategories
  has_many :subcategories, through: :stories_subcategories

  has_many :countries_stories
  has_many :countries, through: :countries_stories

  scope :active, -> { where(status: "live").where(public: true) }
  scope :draft, -> { where(status: "draft") }
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  attr_accessor :age_bracket

  AGE_BRACKET= { toddlers: 5..8, kids: 9..12, teenagers: 13..19, adults: 20..50 }

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true

  before_save :determine_age_bracket, :add_hero_image

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

  def story_images
    content = Nokogiri::HTML::Document.parse self.content

    images = content.css('img').map{ |image| image['src'] }
  end

  def teaser
    string = ""
    content = Nokogiri::HTML::Document.parse self.content
    content.css('p').each do |paragraph|
      string += "<p>" + paragraph + "</p>"
    end

    string = string[0..280] + "..."
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

  def add_hero_image
    hero_image = story_images.first
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
      html_title = Nokogiri::HTML::Document.parse self.title

      title = html_title.at_css('h2').text rescue ""

      if !title.blank?
        title
      else
        "user story about things to do with kids and families in #{self.storiable.display_name rescue ""}"
      end
    end

end
