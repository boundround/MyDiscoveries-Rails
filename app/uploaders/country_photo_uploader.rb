# encoding: utf-8

class CountryPhotoUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "country_photos/#{model.id}"
  end

  process :auto_orient

  # Process files as they are uploaded:
  process :resize_to_fit => [900, 900]

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
