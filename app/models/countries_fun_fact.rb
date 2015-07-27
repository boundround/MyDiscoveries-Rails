class CountriesFunFact < ActiveRecord::Base
  belongs_to :country
  belongs_to :fun_fact
end
