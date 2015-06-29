class Photo < ActiveRecord::Base
  belongs_to :area
  belongs_to :place

  has_many :photos_users
  has_many :users, through: :photos_users

  mount_uploader :path, PhotoUploader
  process_in_background :path
  skip_callback :commit, :after, :remove_path!

  has_paper_trail

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    rows = row.to_h
    photo = Photo.create!(rows)
    photo.remote_path_url = "https://d1w99recw67lvf.cloudfront.net/photos/" + rows['path']
    photo.save!

    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
