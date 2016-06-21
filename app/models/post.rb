class Post < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch

  mount_uploader :hero_photo, PostHeroPhotoUploader

  algoliasearch index_name: "place_production", id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :title, :content, :status, :slug, :minimum_age, :maximum_age

    attribute :url do
      Rails.application.routes.url_helpers.post_path(self)
    end

    attribute :display_name do
      title
    end

    attribute :display_address do
      "Bound Round Story"
    end

    attribute :description do
      content
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
      story_images.map do |photo|
        { url: photo, alt_tag: photo }
      end
    end

    attribute :hero_photo do
      if hero_photo_url.blank?
        if story_images.blank?
          ""
        else
          { url: story_images.first, alt_tag: story_images.first }
        end
      else
        { url: hero_photo_url, alt_tag: hero_photo_url }
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
    attributesToIndex ['display_name', 'unordered(content)', 'unordered(display_address)', 'primary_category', 'subcategories']

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    # customRanking ['desc(likes_count)']

    attributesForFaceting ['main_category', 'age_range', 'subcategory', 'weather', 'price', 'best_time_to_visit', 'accessibility']
  end

  # algoliasearch index_name: "posts", if: :published? do
  #   # list of attribute used to build an Algolia record
  #   attributes :id, :title, :content, :status, :slug, :minimum_age, :maximum_age
  #
  #   synonyms [
  #     ["active", "water sports", "sports", "sport", "adventurous", "adventure", "snow", "beach", "camping"],
  #     ["disabled", "wheelchair access"]
  #   ]
  #
  #   attribute :url do
  #     Rails.application.routes.url_helpers.post_path(self)
  #   end
  #
  #   attribute :display_name do
  #     title
  #   end
  #
  #   attribute :display_address do
  #     "Bound Round Story"
  #   end
  #
  #   attribute :description do
  #     teaser[0..200] + "..."
  #   end
  #
  #   attribute :viator_link do
  #     ""
  #   end
  #
  #   attribute :primary_category do
  #      if self.primary_category
  #       { name: "#{primary_category.name}", identifier: primary_category.identifier}
  #     else
  #       ""
  #     end
  #   end
  #
  #   attribute :result_type do
  #     "Story"
  #   end
  #
  #   attribute :result_icon do
  #     "book"
  #   end
  #
  #   attribute :main_category do
  #     primary_category.name if primary_category.present?
  #   end
  #
  #   attribute :subcategories do
  #     subcategories.map{ |sub| { name: sub.name, identifier: sub.identifier } }
  #   end
  #
  #   attribute :subcategory do
  #     subcategories.subcats.map{|sub| sub.name}
  #   end
  #
  #   attribute :name do
  #     title
  #   end
  #
  #   attribute :photos do
  #     story_images.map do |photo|
  #       { url: photo, alt_tag: photo }
  #     end
  #   end
  #
  #   attribute :hero_photo do
  #     if hero_photo_url.blank?
  #       if story_images.blank?
  #         ""
  #       else
  #         { url: story_images.first, alt_tag: story_images.first }
  #       end
  #     else
  #       { url: hero_photo_url, alt_tag: hero_photo_url }
  #     end
  #   end
  #
  #   attribute :age_range do
  #     if minimum_age.present? and maximum_age.present?
  #       if minimum_age > 12
  #         ["Teens"]
  #       elsif minimum_age > 8 && maximum_age < 13
  #         ["For Ages 9-12"]
  #       elsif minimum_age > 8
  #         ["For Ages 9-12", "Teens"]
  #       elsif maximum_age < 13
  #         ["For Ages 5-8", "For Ages 9-12"]
  #       elsif maximum_age < 9
  #         ["For Ages 5-8"]
  #       else
  #         ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
  #       end
  #     else
  #       ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
  #     end
  #   end
  #
  #   attribute :weather do
  #     subcategories.where(category_type: 'weather').map{ |sub|  sub.name }
  #   end
  #
  #   attribute :price do
  #     subcategories.where(category_type: 'price').map{ |sub|  sub.name }
  #   end
  #
  #   attribute :best_time_to_visit do
  #     subcategories.where(category_type: 'optimum_time').map{ |sub|  sub.name }
  #   end
  #
  #   attribute :accessibility do
  #     subcategories.where(category_type: 'accessibility').map{ |sub|  sub.name }
  #   end
  #
  #    #country and url
  #
  #   # the attributesToIndex` setting defines the attributes
  #   # you want to search in: here `title`, `subtitle` & `description`.
  #   # You need to list them by order of importance. `description` is tagged as
  #   # `unordered` to avoid taking the position of a match into account in that attribute.
  #   attributesToIndex ['display_name', 'unordered(description)', 'unordered(display_address)', 'content', 'status', 'primary_category', 'subcategories', 'sub_subcategory']
  #
  #   # the `customRanking` setting defines the ranking criteria use to compare two matching
  #   # records in case their text-relevance is equal. It should reflect your record popularity.
  #   # customRanking ['desc(likes_count)']
  #
  #   attributesForFaceting ['area', 'main_category', 'age_range', 'subcategory', 'weather', 'price', 'best_time_to_visit', 'accessibility']
  # end


  before_update :regenerate_slug

  scope :active, -> { where(status: "live") }

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  validates :seo_friendly_url, presence: true

  friendly_id :slug_candidates, :use => :slugged

  belongs_to :user
  belongs_to :primary_category

  has_many :places_posts
  has_many :places, through: :places_posts

  has_many :posts_subcategories
  has_many :subcategories, through: :posts_subcategories

  has_many :countries_posts
  has_many :countries, through: :countries_posts

  accepts_nested_attributes_for :places
  accepts_nested_attributes_for :countries

  def story_title
    html_title = Nokogiri::HTML::Document.parse self.title

    title = html_title.at_css('h2').text rescue ""
  end

  def story_images
    content = Nokogiri::HTML::Document.parse self.content

    images = content.css('img').map{ |image| image['src'] }
  end

  def self.all_active_posts
    Rails.cache.fetch("all_posts", expires_in: 12.hours) do
      Post.active.includes(:user).order(created_at: :desc)
    end
  end

  def teaser
    string = ""
    content = Nokogiri::HTML::Document.parse self.content
    content.css('p').each do |paragraph|
      if !paragraph.content.blank?
        string += "<p>" + paragraph + "</p>"
      end
    end

    string = string[0..280] + "..."
  end

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  private
    def algolia_id
      "post_#{id}" # ensure the place, post & country IDs are not conflicting
    end

    def slug_candidates
      :seo_friendly_url
    end

    def regenerate_slug
      if self.seo_friendly_url_changed?
        self.slug = seo_friendly_url.parameterize
      end
    end
end
