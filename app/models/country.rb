class Country < ActiveRecord::Base
  extend FriendlyId
  friendly_id :display_name, :use => :slugged

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  mount_uploader :hero_photo, CountryPhotoUploader

  has_one :area # Capital City

  has_many :countries_photos
  has_many :photos, through: :countries_photos

  has_many :countries_videos
  has_many :videos, through: :countries_videos

  has_many :countries_fun_facts
  has_many :fun_facts, through: :countries_fun_facts

  has_many :countries_famous_faces
  has_many :famous_faces, through: :countries_famous_faces

  has_many :countries_info_bits
  has_many :info_bits, through: :countries_info_bits

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :famous_faces, allow_destroy: true
  accepts_nested_attributes_for :info_bits, allow_destroy: true

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true

  def load_into_soulmate
    if self.published_status == "live"
      loader = Soulmate::Loader.new("country")
      loader.add("term" => display_name.downcase, "display_name" => display_name, "id" => id, "description" => description,
                  "url" => '/countries/' + slug + '.html', "slug" => slug, "placeType" => "country")
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("country")
    loader.remove("id" => self.id)
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      begin
        row = Hash[[header, spreadsheet.row(i)].transpose]
        Country.create!(row.to_h)
      rescue Exception
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, packed: nil, file_warning: :ignore)
      when ".xls" then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
