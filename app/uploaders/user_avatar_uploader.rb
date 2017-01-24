# encoding: utf-8

class UserAvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
   storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "user_avatars/#{model.id}"
  end

  # Process files as they are uploaded:
  process :resize_to_fit => [500, 500]

  process :fix_exif_rotation
  process :quality => 70

  version :large do
    process :cropper
    process :resize_to_fit => [1400, 1400]
  end

  version :thumb_avatar do
    resize_to_fill(100, 100)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  # Rotates the image based on the EXIF Orientation
  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end

  def cropper
    if model.crop_x.present?
      resize_to_limit(600, 600)
      manipulate! do |img|
        g_x = model.crop_x
        g_y = model.crop_y
        g_w = model.crop_w
        g_h = model.crop_h
        geometri = g_w+"x"+g_h+"+"+g_x+"+"+g_y
        img.crop(geometri)
      end
    end
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
