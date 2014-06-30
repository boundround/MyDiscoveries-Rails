class AddPlaceIdToVideos < ActiveRecord::Migration
  def change
    add_reference :videos, :place, index: true
  end
end
