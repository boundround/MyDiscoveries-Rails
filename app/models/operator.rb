class Operator < ActiveRecord::Base
  has_many :offers
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  def slug_candidates
    :name
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
