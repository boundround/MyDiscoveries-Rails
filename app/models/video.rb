class Video < ActiveRecord::Base
  include CustomerApprovable

  before_save :set_approval_time, :check_customer_approved, :validate_youtube_id

  belongs_to :place

  has_many :videos_users
  has_many :users, through: :videos_users

  has_many :countries_videos
  has_many :countries, :through => :countries_videos

  has_paper_trail

  # validates :vimeo_id, presence: true

  validate :video_service_id

  scope :ordered_by_place_name, -> { includes(:area, :place).order('areas.display_name ASC') } #reorder("places.display_name ASC") }

  scope :active, -> { where(status: "live") }
  scope :featured, -> { order("created_at DESC").limit(3) }
  scope :edited, -> { where(status: "edited") }
  scope :preview, -> { where('status=? OR customer_review=?', 'live', 'true') }

  # before_save :validate_vimeo_id

  self.per_page = 200

  attr_accessor :url

  after_initialize :set_url

  def add_or_remove_from_country(country)
    row = CountriesVideo.where(video_id: self.id).where(country_id: country.id)

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
    v = Video.new(row.to_h)
    response = Unirest.get "https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + v.vimeo_id.to_s
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

  # def validate_vimeo_id
  #   key = "bearer " + ENV["VIMEO_OAUTH_KEY"]
  #   response = Unirest.get "https://api.vimeo.com/videos/" + vimeo_id.to_s,
  #                           headers: { "Authorization" => key }
  #   if response.body['user']['name'] == 'Bound Round'
  #     true
  #   else
  #     false
  #   end
  # end

  def update_info
    if self.vimeo_id.present?
      response = Unirest.get("https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + self.vimeo_id.to_s) rescue nil
      self.youtube_id = ""
    elsif self.youtube_id.present?
      response = Unirest.get("http://www.youtube.com/oembed?url=http://www.youtube.com/watch?v=#{self.youtube_id}&format=json") rescue nil
    end

    if response
      self.vimeo_thumbnail = response.body["thumbnail_url"]
      self.title = response.body["title"] if self.title.blank?
      self.description = response.body["description"] if self.description.blank?
    end
  end

  def video_service_id
    errors.add(:base, 'Video Service ID can not be empty.') if vimeo_id.blank? and youtube_id.blank?
  end

  def validate_youtube_id
    unless self.youtube_id.blank?
      if self.youtube_id.match /^http/
        self.youtube_id = self.youtube_id.split('/').last
      end
    end
  end

  private

    def set_url
      if vimeo_id.present?
        self.url= "https://player.vimeo.com/video/" + self.vimeo_id.to_s
      end
      if youtube_id.present?
        self.url= "https://www.youtube.com/embed/" + self.youtube_id.to_s
      end
    end

end
