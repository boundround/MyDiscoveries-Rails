class Photo < ActiveRecord::Base
  belongs_to :area

  mount_uploader :path, PhotoUploader


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    rows = row.to_h
    puts rows
    photo = Photo.create!(rows)
    photo.remote_path_url = "http://a4880de24e34f11e3f92-ce896e8ff886a7b92853892bc040f908.r36.cf4.rackcdn.com/photos/" + rows['path']
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
