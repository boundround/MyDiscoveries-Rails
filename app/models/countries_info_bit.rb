class CountriesInfoBit < ActiveRecord::Base
  belongs_to :country
  belongs_to :info_bit
end
