class PlaceSerializer < ActiveModel::Serializer

  has_many :photos, key: :photo_pages, root: :photo_pages
  has_one :journal_info

  attributes :Area, :Area_Type, :Code, :Game_parameters, :Hero_image, :Hero_image_credit,
              :Icon, :Info_page, :Logo_image, :Logo_image_credit, :PlaceID, :PlaceIntro_Narration_file,
              :PlaceIntro_Narrator, :PlaceIntro_Premium, :Video, :VideoLink, :address_directory,
              :description_directory, :discount_summary, :geolocation_latitude, :geolocation_longitude,
              :identifier, :opening_hours_directory, :phone_number_directory, :terms_and_conditions,
              :venue_name, :website_directory, :Game

  def Area
    object.area.code
  end

  def Area_Type
    object.subscription_level
  end

  def Code
    object.code
  end

  def Game_parameters

  end

  def Hero_image
  end

  def Hero_image_credit
  end

  def Icon
    object.map_icon.path.gsub('vector_icons/', '').gsub(/_.\.(png|svg)/, '')
  end

  def Info_page
    object.description
  end

  def Logo_image
  end

  def Logo_image_credit
  end

  def PlaceID
    object.id
  end

  def PlaceIntro_Narration_file
  end

  def PlaceIntro_Narrator
  end

  def PlaceIntro_Premium
    object.description
  end

  def Video
    unless object.videos.empty?
      video = object.videos.where(priority: 1).first || object.videos.first
      response = Unirest.get "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + video.vimeo_id.to_s
      response.body["title"]
    end
  end

  def VideoLink
    unless object.videos.empty?
      video = object.videos.where(priority: 1).first || object.videos.first
      key = "bearer " + ENV["VIMEO_OAUTH_KEY"]
      response = Unirest.get "https://api.vimeo.com/videos/" + video.vimeo_id.to_s,
                              headers: { "Authorization" => key }
      response.body["files"].last["link"]
    end
  end

  def address_directory
    object.address
  end

  def description_directory
    object.description
  end

  def discount_summary
  end

  def geolocation_latitude
    object.latitude
  end

  def geolocation_longitude
    object.longitude
  end

  def identifier
    if object.identifier.empty?
      object.area.display_name.downcase.gsub(' ', '_') + '_' + object.display_name.downcase.gsub(' ', '_')
    else
      object.identifier
    end
  end

  def opening_hours_directory
    object.opening_hours
  end

  def phone_number_directory
    object.phone_number
  end

  def terms_and_conditions
  end

  def venue_name
    object.display_name
  end

  def website_directory
    object.website
  end

  def Game
    areaName = object.area.display_name.downcase.gsub(' ', '')
    photo = object.photos.where(priority: 1).first || object.photos.first
    photo = photo.path.path.gsub('photos/', '')
    unless object.games.empty?
      if object.games.first.game_type = "jigsaw puzzle"
        game = {
                     "Parameters" => [
                        "Photo",
                        "Pieces"
                      ],
                     "Photo" => "../../../Documents/AirplaneMode/" + areaName +
                                "/" + areaName + ".bundle/games/" + photo,
                     "Bundle" => "Main",
                     "Pieces" => "12",
                     "Path" => "Puzzles/Jigsaw/index.html",
                     "Type" => "Puzzle",
                     "Instructions" => [
                        "Complete the Jigsaw Puzzle!",
                        "Tap pieces to spin them",
                        "Tap, hold and drag to move them"
                      ]
                     }
           game.to_json
      elsif object.games.first.game_type = "slider"
        game = {
                     "Parameters" => [
                        "Photo",
                        "Size"
                      ],
                     "Photo" => "../../../Documents/AirplaneMode/" + areaName +
                                "/" + areaName + ".bundle/games/" + photo,
                     "Bundle" => "Main",
                     "Size" => "3",
                     "Path" => "Puzzles/Sliding/index.html",
                     "Type" => "Puzzle",
                     "Instructions" => [
                        "Complete the Slider Puzzle!",
                        "Slide pieces to reassemble the photo",
                        "Drag each piece with your finger to move"
                      ]
                     }
           game.to_json
      elsif object.games.first.game_type = "word search"
        game = {
                  "Game" => {
                  "Background Color" => "EEEEEE",
                  "Grid Size" => "12",
                  "Border Color" => "999999",
                  # "crap" => "camel,saddle,muster,outback,katatjuta,anangu,humps,sunset,uluru",
                  "Parameters" => [
                                    "Grid Size", "Font", "Font Color",
                                    "Background Color", "Border Color", "Words"
                                  ],
                  "Font Color" => "0000FF",
                  "Bundle" => "Main",
                  "Words" =>  [
                                "", "", "", "", "",
                                "", "","", ""
                              ],
                  "Path" => "Puzzles/WordSearch/demo.html",
                  "Font" => "Handlee",
                  "Type" => "WordSearch",
                  "Instructions" => [
                                      "Find all the words!",
                                      "Tap and drag over hidden words",
                                      "Tap the word in list for help"
                                    ]
         }
                  }
        game.to_json
      else
        ''
      end
    end
  end

end
