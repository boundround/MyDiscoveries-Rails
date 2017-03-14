module Observers::Product
  extend ActiveSupport::Concern

  def display_name
    name
  end

end
