include ActsAsTaggableOn::TagsHelper

module ProgramsHelper

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
