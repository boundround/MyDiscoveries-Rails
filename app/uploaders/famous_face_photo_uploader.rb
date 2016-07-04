# encoding: utf-8

class FamousFacePhotoUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :aws

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "famous_face_photos/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :auto_orient

  # Process files as they are uploaded:
  process :resize_to_fit => [900, 900]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :small do
  #   process :resize_to_fit => [300, 300]
  # end

  # version :medium do
  #   process :resize_to_fit => [500, 500]
  # end

  # version :large do
  #   process :resize_to_fit => [900, 900]
  # end

  # version : do
  #   process :resize_to_fit => [800, 800]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def auto_orient
      manipulate! do |image|
        image.tap(&:auto_orient)
      end
    end

end
