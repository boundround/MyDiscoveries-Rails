# encoding: utf-8

class CompetitionImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "competitions/#{model.id}"
  end

  # Process files as they are uploaded:
  process :quality => 70

  version :small do
    process :resize_to_fit => [500, 500]
  end

  version :large do
    process :resize_to_fit => [1400, 1400]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

