class Post < ActiveRecord::Base
  extend FriendlyId
  include Searchable

  mount_uploader :hero_photo, PostHeroPhotoUploader

  before_update :regenerate_slug

  #scope :active, -> { where(status: "live") }

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  validates :seo_friendly_url, presence: true

  friendly_id :slug_candidates, :use => :slugged

  belongs_to :user
  belongs_to :primary_category

  has_many :places_posts
  has_many :places, through: :places_posts

  has_many :attractions_posts
  has_many :posts, through: :attractions_posts

  has_many :posts_users
  has_many :users, through: :posts_users

  has_many :posts_subcategories
  has_many :subcategories, through: :posts_subcategories

  has_many :countries_posts
  has_many :countries, through: :countries_posts

  accepts_nested_attributes_for :places
  accepts_nested_attributes_for :countries

  def self.active
    where(status: "live")
  end

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
      Post.active.includes(:user).order(publish_date: :desc).order(created_at: :desc)
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
    if self.status == "live"
      true
    else
      false
    end
  end

  private

  def slug_candidates
    :seo_friendly_url
  end

  def regenerate_slug
    if self.seo_friendly_url_changed?
      self.slug = seo_friendly_url.parameterize
    end
  end
end
