class Ship < ActiveRecord::Base
	
	has_many :products, class_name: Spree::Product, dependent: :destroy

	extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :name, presence: true

  mount_uploader :map, ShipMapUploader
  process_in_background :map

  def slug_candidates
    :name
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

end
