# encoding: utf-8

class RegionPhotoUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "region_photos/#{model.id}"
  end

  process :auto_orient
  process :quality => 70

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [102, 102]
  end

  version :small do
    process :resize_to_fit => [500, 500]
  end

  version :medium do
    process :resize_to_fit => [900, 900]
  end

  version :large do
    process :resize_to_fit => [1400, 1400]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def auto_orient
      manipulate! do |image|
        image.tap(&:auto_orient)
      end
    end

end
