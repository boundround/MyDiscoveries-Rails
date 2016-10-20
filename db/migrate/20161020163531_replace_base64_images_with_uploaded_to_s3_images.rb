class ReplaceBase64ImagesWithUploadedToS3Images < ActiveRecord::Migration
  def change
    stories_count = Story.count
    Story.find_each.with_index do |story, story_index|
      story.story_images.each_with_index do |story_image_in_base64, story_image_index|
        story.temp_image_for_base64_convertion = story_image_in_base64
        story.save
        story_image = StoryImage.create(story_id: story.id, file: story.temp_image_for_base64_convertion)
        story.content = story.content.sub(story_image_in_base64, story_image.file.url)
        story.save
        puts "(#{story_index + 1} out of #{stories_count}) " \
             "Story##{story.id}, image #{story_image_index + 1}"
        GC.start
      end
    end
  end
end
