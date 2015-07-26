class CountriesVideo < ActiveRecord::Base
  belongs_to :country
  belongs_to :video
end
