module AttractionsHelper

  def found_in_parent(obj)
    parent_obj = obj.parent.parentable

    if parent_obj.class.to_s == 'Country'
      return link_to parent_obj.display_name, country_path(parent_obj), target: '_blank'
    elsif parent_obj.class.to_s == 'Place'
      return link_to parent_obj.display_name, place_path(parent_obj), target: '_blank'
    elsif parent_obj.class.to_s == 'Attraction'
      return link_to parent_obj.display_name, attraction_path(parent_obj), target: '_blank'
    end
  end

end
