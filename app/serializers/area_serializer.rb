class AreaSerializer < ActiveModel::Serializer

  has_many :places

  attributes :"Area Intro sentence (max 90 characters)_Sound Sprite text",
              :"Area info page (400 characters)", :AreaID, :Centre_latitude, :Centre_longitude,
              :"Content completion date", :Country, :Display_name, :HeroPhoto, :HeroPhotoCredit,
              :"Intro Narration Audio File", :Narrator, :OverviewVideo, :OverviewVideoLink,
              :View_heading, :View_height, :View_latitude, :View_longitude, :identifier, :Northeast_latitude,
              :northeast_longitude, :southwest_latitude, :southeast_latitude

  def places
    object.places.where.not(subscription_level: "out").where.not(subscription_level: "draft")
  end

  define_method("Area Intro sentence (max 90 characters)_Sound Sprite text") do
    object.short_intro
  end

  define_method("Area info page (400 characters)") do
    object.description
  end

  def AreaID
    object.id
  end

  def Centre_latitude
    object.latitude
  end

  def Centre_longitude
    object.longitude
  end

  define_method("Content completion date") do
    object.updated_at
  end

  def Country
    object.country
  end

  def Display_name
    object.display_name
  end

  def HeroPhoto
    unless object.photos.empty?
      photo = object.photos.where(priority: 1).first || object.photos.first
      photo.path.path.gsub('photos/', '') #.gsub(/\.png|\.jpg/i, '')
    end
  end

  def HeroPhotoCredit
    unless object.photos.empty?
      photo = object.photos.where(priority: 1).first || object.photos.first
      photo.credit
    end
  end

  define_method("Intro Narration Audio File") do

  end

  def Narrator

  end

  def OverviewVideo
    unless object.videos.empty?
      video = object.videos.where(priority: 1).first || object.videos.first
      response = Unirest.get "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + video.vimeo_id.to_s
      response.body["title"]
    end
  end

  def OverviewVideoLink
    unless object.videos.empty?
      video = object.videos.where(priority: 1).first || object.videos.first
      key = "bearer " + ENV["VIMEO_OAUTH_KEY"]
      response = Unirest.get "https://api.vimeo.com/videos/" + video.vimeo_id.to_s,
                              headers: { "Authorization" => key }
      response.body["files"].last["link"]
    end
  end

  def View_heading
    # object.view_heading
  end

  def View_height
    # object.view_height
  end

  def View_latitude
    # object.view_latitude
  end

  def View_longitude
    # object.view_longitude
  end

  def identifier
    if object.identifier.empty?
      object.display_name.downcase.gsub(' ', '_')
    else
      object.identifier
    end
  end

  def Northeast_latitude
    # object.northeast_latitude
  end

  def northeast_longitude
    # object.northeast_longitude
  end

  def southwest_latitude
    # object.southeast_latitude
  end

  def southeast_latitude
    # object.southeast_latitude
  end

end
