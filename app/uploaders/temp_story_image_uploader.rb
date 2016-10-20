class TempStoryImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "temp_story_images/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
