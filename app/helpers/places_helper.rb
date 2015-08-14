module PlacesHelper
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
    "https://d1w99recw67lvf.cloudfront.net/category_icons/"+place.categories[0].identifier+"_icon.png"
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
      '<img src="https://d1w99recw67lvf.cloudfront.net/category_icons/'+place.categories[0].identifier+'_icon.png" alt="sights icon"><span>'+place.categories[0].name+'<span>'
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
        allyears += yl_as_csv_string(p.programyearlevels)
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
    #Sort based on year level sort order
    first = String.new('K')
    last = String.new('12')
    @ylvec.each do |yl|
      if allyears.include?(yl) then
        first = yl
        break
      end
    end

    @ylvec.reverse_each do |yl|
      if allyears.include?(yl) then
        last = yl
        break
      end
    end
    
    first+' - '+last
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

  def program_activities(program)
    #Sort based on year level sort order
    yls = ""
    program.programactivities.each do |yl|
      if yls != "" then yls += "," end
      yls += yl.name
    end 
    yls
    #program.programyearlevel_list 
  end
end
