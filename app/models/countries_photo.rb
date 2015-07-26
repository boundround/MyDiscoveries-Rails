class CountriesPhoto < ActiveRecord::Base
  belongs_to :country
  belongs_to :photo
end
