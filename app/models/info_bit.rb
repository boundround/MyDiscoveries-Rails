class InfoBit < ActiveRecord::Base
  mount_uploader :photo, InfoBitPhotoUploader

  has_many :countries_info_bits
  has_many :countries, :through => :countries_info_bits

  scope :active, -> { where(status: "live") }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }
end
