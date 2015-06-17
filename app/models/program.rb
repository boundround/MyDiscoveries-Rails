class Program < ActiveRecord::Base
  belongs_to :place
  has_many :webresources, -> { order "created_at ASC"}

  acts_as_taggable
  acts_as_taggable_on :programyearlevels, :programactivities, :programsubjects

#  after_save :load_into_soulmate
#  before_destroy :remove_from_soulmate
  
  include PgSearch
  pg_search_scope :search, against: [:name, :description],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {webresources: :caption, place: [:display_name, :description] }

  validates_presence_of :name

  def self.import(file)
    puts "Trying to open spreadsheet"
    spreadsheet = open_spreadsheet(file)
    puts "Reading header"
    header = spreadsheet.row(1)
    puts header
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row['place'] != nil then        
        puts row["place"]+", "+row["name"]
        place = Place.find_by display_name: row["place"]
        nothing = 0
        unless place.nil? 
          break if nothing > 20
          row.delete("place")
          if row['webresources'] && row['webresources'] != "" then
            webresources = JSON.parse(row['webresources'])
            row.delete("webresources")
            program = place.programs.create!(row.to_h)
            webresources.each do |key, val|
              program.webresources.create(:caption => key, :path => val)
            end
          else
            row.delete("webresources")
            program = place.programs.create!(row.to_h)
          end
        end
      else
        nothing += 1
      end
    end
  end

  def self.validate_import(file)
    puts "Trying to open spreadsheet"
    spreadsheet = open_spreadsheet(file)
    puts "Reading header"
    header = spreadsheet.row(1)
    puts header
    nothing = 0
    (2..spreadsheet.last_row).each do |i|
      break if nothing > 20
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["place"] != nil then
        puts row["place"]+", "+row["name"]
        place = Place.find_by display_name: row["place"]
        unless place.nil? 
          row.delete("place")
          if row['webresources'] && row['webresources'] != "" then
            webresources = JSON.parse(row['webresources'])
            row.delete("webresources")
  #          program = place.programs.create!(row.to_h)
              puts "Program @ row " + i.to_s + " named " + row["name"] +"Would have been created"
            webresources.each do |key, val|
              puts "Webresource "+key+" Would have been created"
  #            program.webresources.create(:caption => key, :path => val)
            end
          else
            row.delete("webresources")
            puts "Program @ row " + i.to_s + " named " + row["name"] +"Would have been created"
  #          program = place.programs.create!(row.to_h)
          end
        end
      else
        nothing += 1
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

  def load_into_soulmate
#    puts id
#    if self.subscription_level.downcase == 'premium' || self.subscription_level.downcase == 'standard' || self.subscription_level == 'basic'
      loader = Soulmate::Loader.new("program")
      loader.add("term" => self.name.downcase + ' ' + self.description.downcase + ' ' + self.place.display_name.downcase + ' ' + self.place.area.display_name.downcase,
                "display_name" => self.name, "id" => self.id, "latitude" => self.place.latitude, "longitude" => self.place.longitude,
                "url" => '/programs/' + self.id + '.html', "placeType" => "program",
                "area" => {"display_name" => self.place.area.display_name, "country" => self.place.area.country})
  end
      
  def remove_from_soulmate
    loader = Soulmate::Loader.new("program")
    loader.remove("id" => self.id)
  end

  
end
