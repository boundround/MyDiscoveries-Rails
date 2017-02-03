class Operator < ActiveRecord::Base
  STATUSES = ["live", "draft", "removed"]

  has_many :offers
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  validates :name, presence: true

  mount_uploader :logo, OperatorLogoUploader
  process_in_background :logo

  mount_uploader :contract_pdf_file, OperatorPdfUploader
  
  def slug_candidates
    :name
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
