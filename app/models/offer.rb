class Offer < ActiveRecord::Base
  belongs_to :attraction

  has_many :offers_photos, dependent: :destroy
  has_many :photos, through: :offers_photos

  has_many :offers_videos, dependent: :destroy
  has_many :videos, through: :offers_videos

  has_many :offers_attractions, dependent: :destroy
  has_many :attractions, through: :offers_attractions

  has_many :offers_places, dependent: :destroy
  has_many :places, through: :offers_places

  has_many :offers_countries, dependent: :destroy
  has_many :countries, through: :offers_countries

  # has_many :offers_regions
  # has_many :regions, through: :offers_regions

  has_many :offers_subcategories, dependent: :destroy
  has_many :subcategories, through: :offers_subcategories

  validates_presence_of :name

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
end
