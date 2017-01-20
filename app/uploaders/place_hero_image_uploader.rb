# encoding: utf-8

class PlaceHeroImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "hero_images/#{model.id}"
  end

  # Process files as they are uploaded:
  process :resize_to_fit => [1008, nil]
  process :quality => 70

  version :hero do
    process :crop
    process :resize_to_fill => [1008, 200]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop("#{x}x#{y}+#{w}+#{h}")
        return img
      end
    end
  end
end
