module PlacesHelper
  def pick_a_place_photo_url(place)
    place.photos[rand(place.photos.count-1)].path
  end

  def pick_a_program_hero_url(place)
    if place.programs then
      place.programs[rand(place.programs.count-1)].heroimagepath
    else
      place.photos[rand(place.photos.count-1)].path      
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
    
  def place_categories(place)
    res = ""
    place.categories.each do |p|
      res += p.programyearlevel_list
    end
    res
  end

  def place_yearlevels(place)
    res = []
    place.programs.each do |p|
      res = res | p.programyearlevels
    end
    res.join(",")
  end
  
  def program_yearlevels(program)
    #Sort based on year level sort order
    yls = ""
    program.programyearlevels.each do |yl|
      if yls != "" then yls += "," end
      yls += yl.name
    end 
    yls
    #program.programyearlevel_list 
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
end
