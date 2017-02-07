module Observers::Offer
  extend ActiveSupport::Concern

  def display_name
    name
  end

end
