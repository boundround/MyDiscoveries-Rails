class Country < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable

  algoliasearch index_name: "mydiscoveries_#{Rails.env}", id: :algolia_id, if: :published? do

    attributes :display_name, :primary_category_priority, :page_ranking_weight

    attribute :description do
      description.blank? ? "" : description
    end

    attribute :photos do
      photos.order(country_hero: :desc).select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.alt_tag }
      end
    end

    attribute :viator_link do
      ""
    end

    attribute :hero_photo do
      hero_h = photos.where(photos: { hero: true }).first
      hero = {}
      if hero_h.present?
        hero= { url: hero_h.path_url(:small), alt_tag: hero_h.caption }
      else
        hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
      end
      hero
    end

    attribute :has_hero_image do
      photos.exists?(country_hero: true)
    end

    attribute :is_country do
      true
    end

    attribute :is_area do
      true
    end

    attribute :result_type do
      "Country"
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :url do
      @object = self
      Rails.application.routes.url_helpers.country_path(Country.find(@object.id))
    end

    attribute :where_destinations do
      'Countries' if self.class.to_s == 'Country'
    end

    # attributesToIndex ['display_name', 'unordered(description)']
    attributesToIndex [
      'display_name',
      'unordered(description)',
      'age_range',
      'accessible',
      'subcategories',
      'unordered(parents)',
      'unordered(display_address)',
      'unordered(primary_category)',
      'publish_date',
    ]

    customRanking Searchable.custom_ranking

    attributesForFaceting [
      'where_destinations',
      'is_area',
      'main_category',
      'age_range',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility',
    ]
  end

  require 'open_weather'

  default_scope { order('display_name ASC') }

  friendly_id :display_name, :use => [:slugged, :history]

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  mount_uploader :hero_photo, CountryPhotoUploader

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :places

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :reviews
  has_many :stories
  has_many :user_photos
  has_many :fun_facts, -> { order "created_at ASC"}, as: :fun_factable
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable

  has_many :good_to_knows, as: :good_to_knowable
  has_many :deals, as: :dealable

  has_many :countries_discounts
  has_many :discounts, through: :countries_discounts

  has_many :countries_photos
  has_many :old_photos, through: :countries_photos, source: :photo


  has_many :countries_famous_faces
  has_many :famous_faces, through: :countries_famous_faces

  has_many :countries_info_bits
  has_many :info_bits, through: :countries_info_bits

  has_many :countries_posts
  has_many :posts, through: :countries_posts

  has_many :countries_stories
  has_many :stories, through: :countries_stories

  has_many :countries_users
  has_many :users, through: :countries_users

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :offers_countries, dependent: :destroy
  has_many :offers, through: :offers_countries

  has_many :products_countries, class_name: Spree::ProductsCountry, dependent: :destroy
  has_many :products, through: :products_countries, class_name: Spree::Product

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :famous_faces, allow_destroy: true
  accepts_nested_attributes_for :info_bits, allow_destroy: true
  accepts_nested_attributes_for :discounts, allow_destroy: true
  accepts_nested_attributes_for :parent, :allow_destroy => true

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true

  def published?
    if self.published_status == "live"
      true
    else
      false
    end
  end

  def children
    list = childrens.select {|child| child.itemable.present?}
    list = list.map { |child| child.itemable }
  end

  def publish_date
    update_at
  end

  def content
    description
  end

  def load_into_soulmate
    if self.published_status == "live"
      loader = Soulmate::Loader.new("country")
      loader.add("term" => display_name.downcase, "display_name" => display_name, "id" => id, "description" => description,
                  "url" => ('/countries/' + slug + '.html'), "slug" => slug, "placeType" => "country")
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

  def get_parents(place, parents = [])
    if place.parent.blank? || place.parent.parentable == self
      return parents
    elsif place.parent.parentable.blank?
      return parents
    elsif place.parent.parentable == place
      return parents
    else
      parents << place.parent.parentable
      get_parents(place.parent.parentable, parents)
    end
  end

  def status
    published_status
  end

  def country_photos
    photos = (self.user_photos.where(status:"live") + self.photos).uniq
  end

  def country_stories
    stories = self.posts.active
    stories += self.stories.active
    stories = stories.sort{|x, y| x.publish_date <=> y.publish_date}.reverse
  end

  def should_generate_new_friendly_id?
    slug.blank? || display_name_changed?
  end

  def country_codes_by_name
    {"Afghanistan"=>"AF", "Åland Islands"=>"AX", "Albania"=>"AL", "Algeria"=>"DZ", "American Samoa"=>"AS", "Andorra"=>"AD", "Angola"=>"AO", "Anguilla"=>"AI", "Antarctica"=>"AQ", "Antigua and Barbuda"=>"AG", "Argentina"=>"AR", "Armenia"=>"AM", "Aruba"=>"AW", "Australia"=>"AU", "Austria"=>"AT", "Azerbaijan"=>"AZ", "Bahamas"=>"BS", "Bahrain"=>"BH", "Bangladesh"=>"BD", "Barbados"=>"BB", "Belarus"=>"BY", "Belgium"=>"BE", "Belize"=>"BZ", "Benin"=>"BJ", "Bermuda"=>"BM", "Bhutan"=>"BT", "Bolivia, Plurinational State of"=>"BO", "Bonaire, Sint Eustatius and Saba"=>"BQ", "Bosnia and Herzegovina"=>"BA", "Botswana"=>"BW", "Bouvet Island"=>"BV", "Brazil"=>"BR", "British Indian Ocean Territory"=>"IO", "Brunei Darussalam"=>"BN", "Bulgaria"=>"BG", "Burkina Faso"=>"BF", "Burundi"=>"BI", "Cambodia"=>"KH", "Cameroon"=>"CM", "Canada"=>"CA", "Cape Verde"=>"CV", "Cayman Islands"=>"KY", "Central African Republic"=>"CF", "Chad"=>"TD", "Chile"=>"CL", "China"=>"CN", "Christmas Island"=>"CX", "Cocos (Keeling) Islands"=>"CC", "Colombia"=>"CO", "Comoros"=>"KM", "Congo"=>"CG", "Congo, the Democratic Republic of the"=>"CD", "Cook Islands"=>"CK", "Costa Rica"=>"CR", "Côte d'Ivoire"=>"CI", "Croatia"=>"HR", "Cuba"=>"CU", "Curaçao"=>"CW", "Cyprus"=>"CY", "Czech Republic"=>"CZ", "Denmark"=>"DK", "Djibouti"=>"DJ", "Dominica"=>"DM", "Dominican Republic"=>"DO", "Ecuador"=>"EC", "Egypt"=>"EG", "El Salvador"=>"SV", "Equatorial Guinea"=>"GQ", "Eritrea"=>"ER", "Estonia"=>"EE", "Ethiopia"=>"ET", "Falkland Islands (Malvinas)"=>"FK", "Faroe Islands"=>"FO", "Fiji"=>"FJ", "Finland"=>"FI", "France"=>"FR", "French Guiana"=>"GF", "French Polynesia"=>"PF", "French Southern Territories"=>"TF", "Gabon"=>"GA", "Gambia"=>"GM", "Georgia"=>"GE", "Germany"=>"DE", "Ghana"=>"GH", "Gibraltar"=>"GI", "Greece"=>"GR", "Greenland"=>"GL", "Grenada"=>"GD", "Guadeloupe"=>"GP", "Guam"=>"GU", "Guatemala"=>"GT", "Guernsey"=>"GG", "Guinea"=>"GN", "Guinea-Bissau"=>"GW", "Guyana"=>"GY", "Haiti"=>"HT", "Heard Island and McDonald Islands"=>"HM", "Holy See (Vatican City State)"=>"VA", "Honduras"=>"HN", "Hong Kong"=>"HK", "Hungary"=>"HU", "Iceland"=>"IS", "India"=>"IN", "Indonesia"=>"ID", "Iran, Islamic Republic of"=>"IR", "Iraq"=>"IQ", "Ireland"=>"IE", "Isle of Man"=>"IM", "Israel"=>"IL", "Italy"=>"IT", "Jamaica"=>"JM", "Japan"=>"JP", "Jersey"=>"JE", "Jordan"=>"JO", "Kazakhstan"=>"KZ", "Kenya"=>"KE", "Kiribati"=>"KI", "Korea, Democratic People's Republic of"=>"KP", "Korea, Republic of"=>"KR", "Kuwait"=>"KW", "Kyrgyzstan"=>"KG", "Lao People's Democratic Republic"=>"LA", "Latvia"=>"LV", "Lebanon"=>"LB", "Lesotho"=>"LS", "Liberia"=>"LR", "Libya"=>"LY", "Liechtenstein"=>"LI", "Lithuania"=>"LT", "Luxembourg"=>"LU", "Macao"=>"MO", "Macedonia, the former Yugoslav Republic of"=>"MK", "Madagascar"=>"MG", "Malawi"=>"MW", "Malaysia"=>"MY", "Maldives"=>"MV", "Mali"=>"ML", "Malta"=>"MT", "Marshall Islands"=>"MH", "Martinique"=>"MQ", "Mauritania"=>"MR", "Mauritius"=>"MU", "Mayotte"=>"YT", "Mexico"=>"MX", "Micronesia, Federated States of"=>"FM", "Moldova, Republic of"=>"MD", "Monaco"=>"MC", "Mongolia"=>"MN", "Montenegro"=>"ME", "Montserrat"=>"MS", "Morocco"=>"MA", "Mozambique"=>"MZ", "Myanmar"=>"MM", "Namibia"=>"NA", "Nauru"=>"NR", "Nepal"=>"NP", "Netherlands"=>"NL", "New Caledonia"=>"NC", "New Zealand"=>"NZ", "Nicaragua"=>"NI", "Niger"=>"NE", "Nigeria"=>"NG", "Niue"=>"NU", "Norfolk Island"=>"NF", "Northern Mariana Islands"=>"MP", "Norway"=>"NO", "Oman"=>"OM", "Pakistan"=>"PK", "Palau"=>"PW", "Palestine, State of"=>"PS", "Panama"=>"PA", "Papua New Guinea"=>"PG", "Paraguay"=>"PY", "Peru"=>"PE", "Philippines"=>"PH", "Pitcairn"=>"PN", "Poland"=>"PL", "Portugal"=>"PT", "Puerto Rico"=>"PR", "Qatar"=>"QA", "Réunion"=>"RE", "Romania"=>"RO", "Russian Federation"=>"RU", "Rwanda"=>"RW", "Saint Barthélemy"=>"BL", "Saint Helena, Ascension and Tristan da Cunha"=>"SH", "Saint Kitts and Nevis"=>"KN", "Saint Lucia"=>"LC", "Saint Martin (French part)"=>"MF", "Saint Pierre and Miquelon"=>"PM", "Saint Vincent and the Grenadines"=>"VC", "Samoa"=>"WS", "San Marino"=>"SM", "Sao Tome and Principe"=>"ST", "Saudi Arabia"=>"SA", "Senegal"=>"SN", "Serbia"=>"RS", "Seychelles"=>"SC", "Sierra Leone"=>"SL", "Singapore"=>"SG", "Sint Maarten (Dutch part)"=>"SX", "Slovakia"=>"SK", "Slovenia"=>"SI", "Solomon Islands"=>"SB", "Somalia"=>"SO", "South Africa"=>"ZA", "South Georgia and the South Sandwich Islands"=>"GS", "South Sudan"=>"SS", "Spain"=>"ES", "Sri Lanka"=>"LK", "Sudan"=>"SD", "Suriname"=>"SR", "Svalbard and Jan Mayen"=>"SJ", "Swaziland"=>"SZ", "Sweden"=>"SE", "Switzerland"=>"CH", "Syrian Arab Republic"=>"SY", "Taiwan, Province of China"=>"TW", "Tajikistan"=>"TJ", "Tanzania, United Republic of"=>"TZ", "Thailand"=>"TH", "Timor-Leste"=>"TL", "Togo"=>"TG", "Tokelau"=>"TK", "Tonga"=>"TO", "Trinidad and Tobago"=>"TT", "Tunisia"=>"TN", "Turkey"=>"TR", "Turkmenistan"=>"TM", "Turks and Caicos Islands"=>"TC", "Tuvalu"=>"TV", "Uganda"=>"UG", "Ukraine"=>"UA", "United Arab Emirates"=>"AE", "United Kingdom"=>"GB", "United States"=>"US", "United States Minor Outlying Islands"=>"UM", "Uruguay"=>"UY", "Uzbekistan"=>"UZ", "Vanuatu"=>"VU", "Venezuela, Bolivarian Republic of"=>"VE", "Viet Nam"=>"VN", "Virgin Islands, British"=>"VG", "Virgin Islands, U.S."=>"VI", "Wallis and Futuna"=>"WF", "Western Sahara"=>"EH", "Yemen"=>"YE", "Zambia"=>"ZM", "Zimbabwe"=>"ZW"}
  end

  def country_codes_by_two_letter_code
    {"AF"=>"Afghanistan", "AX"=>"Åland Islands", "AL"=>"Albania", "DZ"=>"Algeria", "AS"=>"American Samoa", "AD"=>"Andorra", "AO"=>"Angola", "AI"=>"Anguilla", "AQ"=>"Antarctica", "AG"=>"Antigua and Barbuda", "AR"=>"Argentina", "AM"=>"Armenia", "AW"=>"Aruba", "AU"=>"Australia", "AT"=>"Austria", "AZ"=>"Azerbaijan", "BS"=>"Bahamas", "BH"=>"Bahrain", "BD"=>"Bangladesh", "BB"=>"Barbados", "BY"=>"Belarus", "BE"=>"Belgium", "BZ"=>"Belize", "BJ"=>"Benin", "BM"=>"Bermuda", "BT"=>"Bhutan", "BO"=>"Bolivia, Plurinational State of", "BQ"=>"Bonaire, Sint Eustatius and Saba", "BA"=>"Bosnia and Herzegovina", "BW"=>"Botswana", "BV"=>"Bouvet Island", "BR"=>"Brazil", "IO"=>"British Indian Ocean Territory", "BN"=>"Brunei Darussalam", "BG"=>"Bulgaria", "BF"=>"Burkina Faso", "BI"=>"Burundi", "KH"=>"Cambodia", "CM"=>"Cameroon", "CA"=>"Canada", "CV"=>"Cape Verde", "KY"=>"Cayman Islands", "CF"=>"Central African Republic", "TD"=>"Chad", "CL"=>"Chile", "CN"=>"China", "CX"=>"Christmas Island", "CC"=>"Cocos (Keeling) Islands", "CO"=>"Colombia", "KM"=>"Comoros", "CG"=>"Congo", "CD"=>"Congo, the Democratic Republic of the", "CK"=>"Cook Islands", "CR"=>"Costa Rica", "CI"=>"Côte d'Ivoire", "HR"=>"Croatia", "CU"=>"Cuba", "CW"=>"Curaçao", "CY"=>"Cyprus", "CZ"=>"Czech Republic", "DK"=>"Denmark", "DJ"=>"Djibouti", "DM"=>"Dominica", "DO"=>"Dominican Republic", "EC"=>"Ecuador", "EG"=>"Egypt", "SV"=>"El Salvador", "GQ"=>"Equatorial Guinea", "ER"=>"Eritrea", "EE"=>"Estonia", "ET"=>"Ethiopia", "FK"=>"Falkland Islands (Malvinas)", "FO"=>"Faroe Islands", "FJ"=>"Fiji", "FI"=>"Finland", "FR"=>"France", "GF"=>"French Guiana", "PF"=>"French Polynesia", "TF"=>"French Southern Territories", "GA"=>"Gabon", "GM"=>"Gambia", "GE"=>"Georgia", "DE"=>"Germany", "GH"=>"Ghana", "GI"=>"Gibraltar", "GR"=>"Greece", "GL"=>"Greenland", "GD"=>"Grenada", "GP"=>"Guadeloupe", "GU"=>"Guam", "GT"=>"Guatemala", "GG"=>"Guernsey", "GN"=>"Guinea", "GW"=>"Guinea-Bissau", "GY"=>"Guyana", "HT"=>"Haiti", "HM"=>"Heard Island and McDonald Islands", "VA"=>"Holy See (Vatican City State)", "HN"=>"Honduras", "HK"=>"Hong Kong", "HU"=>"Hungary", "IS"=>"Iceland", "IN"=>"India", "ID"=>"Indonesia", "IR"=>"Iran, Islamic Republic of", "IQ"=>"Iraq", "IE"=>"Ireland", "IM"=>"Isle of Man", "IL"=>"Israel", "IT"=>"Italy", "JM"=>"Jamaica", "JP"=>"Japan", "JE"=>"Jersey", "JO"=>"Jordan", "KZ"=>"Kazakhstan", "KE"=>"Kenya", "KI"=>"Kiribati", "KP"=>"Korea, Democratic People's Republic of", "KR"=>"Korea, Republic of", "KW"=>"Kuwait", "KG"=>"Kyrgyzstan", "LA"=>"Lao People's Democratic Republic", "LV"=>"Latvia", "LB"=>"Lebanon", "LS"=>"Lesotho", "LR"=>"Liberia", "LY"=>"Libya", "LI"=>"Liechtenstein", "LT"=>"Lithuania", "LU"=>"Luxembourg", "MO"=>"Macao", "MK"=>"Macedonia, the former Yugoslav Republic of", "MG"=>"Madagascar", "MW"=>"Malawi", "MY"=>"Malaysia", "MV"=>"Maldives", "ML"=>"Mali", "MT"=>"Malta", "MH"=>"Marshall Islands", "MQ"=>"Martinique", "MR"=>"Mauritania", "MU"=>"Mauritius", "YT"=>"Mayotte", "MX"=>"Mexico", "FM"=>"Micronesia, Federated States of", "MD"=>"Moldova, Republic of", "MC"=>"Monaco", "MN"=>"Mongolia", "ME"=>"Montenegro", "MS"=>"Montserrat", "MA"=>"Morocco", "MZ"=>"Mozambique", "MM"=>"Myanmar", "NA"=>"Namibia", "NR"=>"Nauru", "NP"=>"Nepal", "NL"=>"Netherlands", "NC"=>"New Caledonia", "NZ"=>"New Zealand", "NI"=>"Nicaragua", "NE"=>"Niger", "NG"=>"Nigeria", "NU"=>"Niue", "NF"=>"Norfolk Island", "MP"=>"Northern Mariana Islands", "NO"=>"Norway", "OM"=>"Oman", "PK"=>"Pakistan", "PW"=>"Palau", "PS"=>"Palestine, State of", "PA"=>"Panama", "PG"=>"Papua New Guinea", "PY"=>"Paraguay", "PE"=>"Peru", "PH"=>"Philippines", "PN"=>"Pitcairn", "PL"=>"Poland", "PT"=>"Portugal", "PR"=>"Puerto Rico", "QA"=>"Qatar", "RE"=>"Réunion", "RO"=>"Romania", "RU"=>"Russian Federation", "RW"=>"Rwanda", "BL"=>"Saint Barthélemy", "SH"=>"Saint Helena, Ascension and Tristan da Cunha", "KN"=>"Saint Kitts and Nevis", "LC"=>"Saint Lucia", "MF"=>"Saint Martin (French part)", "PM"=>"Saint Pierre and Miquelon", "VC"=>"Saint Vincent and the Grenadines", "WS"=>"Samoa", "SM"=>"San Marino", "ST"=>"Sao Tome and Principe", "SA"=>"Saudi Arabia", "SN"=>"Senegal", "RS"=>"Serbia", "SC"=>"Seychelles", "SL"=>"Sierra Leone", "SG"=>"Singapore", "SX"=>"Sint Maarten (Dutch part)", "SK"=>"Slovakia", "SI"=>"Slovenia", "SB"=>"Solomon Islands", "SO"=>"Somalia", "ZA"=>"South Africa", "GS"=>"South Georgia and the South Sandwich Islands", "SS"=>"South Sudan", "ES"=>"Spain", "LK"=>"Sri Lanka", "SD"=>"Sudan", "SR"=>"Suriname", "SJ"=>"Svalbard and Jan Mayen", "SZ"=>"Swaziland", "SE"=>"Sweden", "CH"=>"Switzerland", "SY"=>"Syrian Arab Republic", "TW"=>"Taiwan, Province of China", "TJ"=>"Tajikistan", "TZ"=>"Tanzania, United Republic of", "TH"=>"Thailand", "TL"=>"Timor-Leste", "TG"=>"Togo", "TK"=>"Tokelau", "TO"=>"Tonga", "TT"=>"Trinidad and Tobago", "TN"=>"Tunisia", "TR"=>"Turkey", "TM"=>"Turkmenistan", "TC"=>"Turks and Caicos Islands", "TV"=>"Tuvalu", "UG"=>"Uganda", "UA"=>"Ukraine", "AE"=>"United Arab Emirates", "GB"=>"United Kingdom", "US"=>"United States", "UM"=>"United States Minor Outlying Islands", "UY"=>"Uruguay", "UZ"=>"Uzbekistan", "VU"=>"Vanuatu", "VE"=>"Venezuela, Bolivarian Republic of", "VN"=>"Viet Nam", "VG"=>"Virgin Islands, British", "VI"=>"Virgin Islands, U.S.", "WF"=>"Wallis and Futuna", "EH"=>"Western Sahara", "YE"=>"Yemen", "ZM"=>"Zambia", "ZW"=>"Zimbabwe"}
  end


  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, packed: nil, file_warning: :ignore)
      when ".xls" then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  private
    def algolia_id
      "country_#{id}" # ensure the countrt & place IDs are not conflicting
    end

end
