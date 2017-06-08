class TabInfo < ActiveRecord::Base

	mount_uploader :image, TabInfoUploader
  process_in_background :image

  validates :title, presence: true
	belongs_to :tab_infoable, polymorphic: true

end