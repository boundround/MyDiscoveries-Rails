class Competition < ActiveRecord::Base

  mount_uploader :image, CompetitionImageUploader

  scope :active, -> { where(status: "live") }

end
