class FamousFace < ActiveRecord::Base
  mount_uploader :photo, FamousFacePhotoUploader

  has_many :countries_famous_faces
  has_many :countries, :through => :countries_famous_faces

  scope :active, -> { where(status: "live") }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }

end
