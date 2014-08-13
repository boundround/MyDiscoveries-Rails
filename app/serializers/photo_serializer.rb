class PhotoSerializer < ActiveModel::Serializer
  attributes :"Fun Fact Reference", :FunFactID, :FunFact_sprite, :"NOT READY SOUND SPRITES",
              :"Photo credit", :PlaceID, :Sound_sprite, :StoryPageID, :"Swapped out Fun Fact text",
              :image_file_name, :sound_sprite_audio_file

  define_method("Fun Fact Reference") do
  end

  def FunFactID
  end

  def FunFact_sprite
    object.caption
  end

  define_method("NOT READY SOUND SPRITES") do
  end

  define_method("Photo credit") do
    object.credit
  end

  def PlaceID
    object.place_id
  end

  def Sound_sprite
  end

  def StoryPageID
    place = Place.find(object.place_id)
    photos = place.photos
    story_page_id = photos.find_index(object)
    story_page_id + 1
  end

  define_method("Swapped out Fun Fact text") do
  end

  def image_file_name
    object.path.path.gsub('photos/', '').gsub(/\.(png|jpg)/, '')
  end

  def sound_sprite_audio_file
  end
end
