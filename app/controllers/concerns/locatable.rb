module Locatable
	extend ActiveSupport::Concern

	def current_user_location
		if current_user
			address
		end	
	end

  def address
    possible_locations= get_location
    #just use the first possible location
    possible_locations.blank? ? nil : possible_locations.first.address
  end

  def get_location cache= true
    if @location.nil?
      @location= location
    else
      @location= cache ? @location : location
    end
  end

  def location
    base = Geocoder.search Rails.env.development? ? '180.245.90.205' : request.ip #use sample ip address if rails.env.development?
    unless base.blank?
      lat= base.first.latitude
      lon= base.first.longitude
      possible_locations= Geocoder.search "#{lat}, #{lon}"
      base= possible_locations
    end
    base
  end

end