class Post < ActiveRecord::Base
  extend FriendlyId

  validates :title, presence: true
  validates :content, presence: true
  validates :credit, presence: true

  friendly_id :slug_candidates, :use => :slugged

  belongs_to :user

  has_many :places_posts
  has_many :places, through: :places_posts

  private
    def slug_candidates
      :title
    end
end
