class FamousFace < ActiveRecord::Base
  mount_uploader :photo, FamousFacePhotoUploader

  has_many :countries_famous_faces
  has_many :countries, :through => :countries_famous_faces
end