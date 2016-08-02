class Page < ActiveRecord::Base
  mount_uploader :hero_image, PageHeroUploader

  validates :title, presence: true
end
