module PlacesHelper

  def create_breadcrumb_for(place)
    breadcrumb = ""
    parents = place.get_parents(place)

    parents.delete_if {|parent| parent.status != "live"}

    if !parents.blank?
      parents.reverse_each do |parent|
        if parent.class.to_s == "Place"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", place_path(parent), class: "breadcrumbs__link"
        elsif parent.class.to_s == "Country"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", country_path(parent), class: "breadcrumbs__link"
        elsif parent.class.to_s == "Attraction"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", attraction_path(parent), class: "breadcrumbs__link"
        elsif parent.class.to_s == "Region"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", region_path(parent), class: "breadcrumbs__link"
        end
      end
    end

    breadcrumb += "<span class='breadcrumbs__link'>" + place.display_name.upcase + "</span>"
  end

  def provide_meta_description_for(place)
    if place.meta_description.present?
      place.meta_description
    elsif place.meta_description.blank? && place.description.present?
      place.description[0..280]
    else
      ""
    end
  end

  def display_boolean_place_category(place, subcategory)
    if place.subcategories.include?(subcategory)
      "1"
    else
      "0"
    end
  end

  def pick_a_place_hero_url(place)
    place.photos[0].path
  end

  def pick_a_place_photo_url(place)
    if place.photos.present?
      asset_path(place.photos[0].path_url(:small))
    end
  end

  def get_program_or_place_hero_url(program)
    if program.heroimagepath then
      program.heroimagepath
    else
      pick_a_place_hero_url(program.place)
    end
  end

  def first_category_icon(place)
    "https://d1w99recw67lvf.cloudfront.net/category_icons/activity_icon.png"
  end

  def yl_as_csv_string(a_programyearlevels)
    yls = ""
    a_programyearlevels.each do |yl|
      if yls != "" then yls += "," end
      yls += yl.name
    end
    yls
  end

  def place_yearlevels(place)
    allyears = String.new
    if place.programs then
      place.programs.each do |p|
        allyears += yl_as_csv_string(p.programyearlevels) + ","
      end
    end
    get_yearlevel_range(allyears)
  end

  def program_yearlevels(program)
    get_yearlevel_range(yl_as_csv_string(program.programyearlevels))
  end

  #Using _list forces goes back to the database!
  #Avoid doing this!

  def get_yearlevel_range(allyears)
    @ylvec = ['F','K','1','2','3','4','5','6','7','8','9','10','11','12']
    #Sort based on year level sort order
    first = String.new('')
    last = String.new('')

    als = allyears.split(",")

    @ylvec.each do |yl|
      als.each do |al|
        if al == yl then
          first = yl
          break
        end
      end
      if first != '' then
        break
      end
    end

    @ylvec.reverse_each do |yl|
      als.each do |al|
        if al == yl then
          last = yl
          break
        end
      end
      if last != '' then
        break
      end
    end

    if first == last then
      first
    else
      first+' - '+last
    end

  end

  def program_subjects(program)
    #Sort based on year level sort order
    yls = ""
    program.programsubjects.each do |yl|
      if yls != "" then yls += "," end
      yls += yl.name
    end
    yls
  end

  def program_subjects_max(program,max_num)
    #Sort based on year level sort order
    yls = ""
    idx = 0
    program.programsubjects.each do |yl|
      if yls != "" then yls += ", " end
      yls += yl.name
      idx = idx + 1
      break if idx > max_num
    end
    yls
  end

  def program_activities(program)
    #Sort based on year level sort order
    pas = ""
    program.programactivities.each do |pa|
      if pas != "" then pas += ", " end
      pas += pa.name
    end
    pas
  end
  
  def create_marker(map_marker)
    marker = []
    map_marker.each do |map|
      if map.present?
        # ['Sydney', 'description', 'telephone', 'email', 'web', -33.865079, 151.212088, '/assets/mydiscoveries_icon/i/map/map-point.png']
        marker.push([map.display_name||"", map.description||"",
                     map.phone_number||"", map.email||"", map.website||"", map.latitude||"", map.longitude||"",
                     map.map_icon||'/assets/mydiscoveries_icon/i/map/map-point.png'])
      end
    end
    marker
  end

end
