class Discount < ActiveRecord::Base
  include CustomerApprovable

  before_save :set_approval_time, :check_customer_approved

  belongs_to :place
  belongs_to :country

  has_paper_trail

  scope :active, -> { where(status: "live") }
  scope :edited, -> { where(status: "edited") }
  scope :preview, -> { where('status=? OR customer_review=?', 'live', 'true') }

  def add_or_remove_from_country(country)
    row = CountriesDiscount.where(discount_id: self.id).where(country_id: country.id)

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

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    Discount.create!(row.to_h)
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
