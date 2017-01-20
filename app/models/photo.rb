class Photo < ActiveRecord::Base
  include CustomerApprovable

  before_save :set_approval_time, :check_customer_approved

  belongs_to :photoable, polymorphic: true

  has_many :countries_photos
  has_many :countries, :through => :countries_photos

  has_many :photos_users
  has_many :users, through: :photos_users

  has_many :offers_photos, dependent: :destroy
  has_many :offers, through: :offers_photos

  mount_uploader :path, PhotoUploader

  skip_callback :commit, :after, :remove_path!

  has_paper_trail

  scope :active, -> { where(status: "live") }
  scope :edited, -> { where(status: "edited") }
  scope :preview, -> { where('status=? OR customer_review=?', 'live', 'true') }

  def add_or_remove_from_country(country)
    row = CountriesPhoto.where(photo_id: self.id).where(country_id: country.id)

    if self.country_include
      if row.blank?
        self.countries << country
      end
    else
      if row.length > 0
        self.countries.delete(country)
      end
    end
  end

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

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
