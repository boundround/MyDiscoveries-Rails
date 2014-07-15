class Video < ActiveRecord::Base
  belongs_to :area
  belongs_to :place

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    v = Video.new(row.to_h)
    response = Unirest.get "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + v.vimeo_id.to_s
    v.vimeo_thumbnail = response.body["thumbnail_url"]
    v.save
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
