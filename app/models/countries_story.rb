class CountriesStory < ActiveRecord::Base
  belongs_to :story
  belongs_to :country
end
