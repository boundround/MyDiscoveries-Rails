class CountriesFamousFace < ActiveRecord::Base
  belongs_to :country
  belongs_to :famous_face
end
