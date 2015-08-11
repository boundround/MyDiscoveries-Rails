class Game < ActiveRecord::Base
  include CustomerApprovable

  before_save :set_approval_time, :check_customer_approved

  belongs_to :place
  belongs_to :area

  has_many :games_users
  has_many :users, through: :games_users

  before_save :add_instructions #:create_thumbnail

  mount_uploader :thumbnail, GameThumbnailUploader

  scope :ordered_by_place_name, -> { joins(:place).order('places.display_name') }

  scope :active, -> { where(status: "live") }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }

  self.per_page = 50

  has_paper_trail

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    Game.create!(row.to_h)
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

  def add_instructions
    if self.game_type == 'jigsaw puzzle'
      self.instructions = "Complete the Jigsaw Puzzle!<br>Tap pieces to spin them<br>Tap, hold and drag to move them"
    elsif self.game_type == 'word search'
      self.instructions = "Find all the words!<br>Tap and drag over hidden words<br>Tap the word in list for help"
    elsif self.game_type == 'slider'
      self.instructions = "Complete the Slider Puzzle!<br>Slide pieces to reassemble the photo<br>Drag each piece with your finger to move"
    end
  end

  def create_thumbnail
    puts self.id
    if self.game_type == 'jigsaw puzzle' || self.game_type == 'slider'
      self.remote_thumbnail_url = self.url.match(/\=.*(\.jpg|\.png|\.svg)/i)[0].gsub("=", "")
    end
  end

end
