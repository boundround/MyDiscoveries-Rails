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

  def valid_program_subject_tags()
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: "programsubjects").uniq.pluck(:name)
  end
end
