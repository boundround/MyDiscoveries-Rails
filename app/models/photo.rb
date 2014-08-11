class Photo < ActiveRecord::Base
  # belongs_to :photoable, :polymorphic => true

  mount_uploader :path, PhotoUploader
  skip_callback :commit, :after, :remove_path!


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    rows = row.to_h
    photo = Photo.create!(rows)
    photo.remote_path_url = "http://905b36b589a2b874c91c-45f6b5af0793f525f377b3a35890f483.r36.cf4.rackcdn.com/photos/" + rows['path']
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
