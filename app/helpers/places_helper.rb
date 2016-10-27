module PlacesHelper

  def create_breadcrumb_for(place)
    breadcrumb = ""
    parents = place.get_parents(place)

    if !parents.blank?
      parents.reverse_each do |parent|
        if parent.class.to_s == "Place"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", place_path(parent)
          breadcrumb += " / "
        elsif parent.class.to_s == "Country"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", country_path(parent)
          breadcrumb += " / "
        elsif parent.class.to_s == "Attraction"
          breadcrumb += link_to "#{parent.display_name.upcase rescue ''}", attraction_path(parent)
          breadcrumb += " / "
        end
      end
    end

    breadcrumb += place.display_name.upcase
  end

  def link_to_parent(place)
    if !place.parent.blank?
      link_to (place.parent.display_name), place_path(place.parent)
    elsif !place.country.blank?
      link_to (place.country.display_name), country_path(place.country)
    else
      ''
    end
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
    #counts kill performance!
#    place.photos[rand(place.photos.size-1)].path
    place.photos[0].path
  end
  def pick_a_place_photo_url(place)
#    asset_path(place.photos[rand(place.photos.size-1)].path_url(:small))
    asset_path(place.photos[0].path_url(:small))
  end

  def pick_a_program_hero_url(place)
    if place.programs then
#      p1 = place.programs[rand(place.programs.size-1)].heroimagepath
      p1 = place.programs[0].heroimagepath
    end

    if !p1 then
      pick_a_place_hero_url(place)
    else
      p1
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

  def valid_program_activity_tags_csv()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programactivities").uniq.pluck(:name).join(", ")
  end

  def valid_program_activity_tags()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programactivities").uniq.pluck(:name)
  end

  def valid_program_yearlevel_tags()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programyearlevels").uniq.pluck(:name)
  end

  def valid_program_yearlevel_tags_csv()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programyearlevels").uniq.pluck(:name).join(", ")
  end

  def valid_program_subject_tags()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programsubjects").uniq.pluck(:name)
  end

  def place_getcategory_icon_img_span(place)
    if place.categories[0] then
      '<img src="https://d1w99recw67lvf.cloudfront.net/category_icons/activity_icon.png" alt="sights icon"><span>activity<span>'
    end
  end

  # def place_categories(place)
  #   res = String.new
  #   place.categories.each do |p|
  #     res += p.programyearlevel_list.to_s
  #   end
  # end
  #
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
  def program_yearlevels_using_list(program)
    get_yearlevel_range(program.programyearlevel_list.to_s)
  end

  def get_yearlevel_range(allyears)
    @ylvec = ['F','K','1','2','3','4','5','6','7','8','9','10','11','12']
    #Sort based on year level sort order
    first = String.new('')
    last = String.new('')

    als = allyears.split(",")

    @ylvec.each do |yl|
      als.each do |al|
#        puts "al = " + al + " : yl = " + yl
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
#        puts "al = " + al + " : yl = " + yl
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
    #program.programyearlevel_list
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
    #program.programyearlevel_list
  end

  def program_activities(program)
    #Sort based on year level sort order
    pas = ""
    program.programactivities.each do |pa|
      if pas != "" then pas += ", " end
      pas += pa.name
    end
    pas
    #program.programyearlevel_list
  end
end
