class CustomReportsController < ApplicationController

  def photo_errors
    @photos = Photo.where('place_id is not null')
    @photos = @photos.select {|photo| photo.path_url.blank? }
  end
end
