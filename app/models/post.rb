class Post < ActiveRecord::Base
  extend FriendlyId

  before_update :regenerate_slug

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  validates :seo_friendly_url, presence: true

  friendly_id :slug_candidates, :use => :slugged

  belongs_to :user

  has_many :places_posts
  has_many :places, through: :places_posts

  has_many :posts_subcategories
  has_many :subcategories, through: :posts_subcategories

  has_many :countries_posts
  has_many :countries, through: :countries_posts

  accepts_nested_attributes_for :places
  accepts_nested_attributes_for :countries

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
