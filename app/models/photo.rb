class Photo < ActiveRecord::Base
  belongs_to :area

  # mount_uploader :path, PhotoUploader

end
