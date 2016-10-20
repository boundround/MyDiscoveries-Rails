class StoryImage < ActiveRecord::Base
  belongs_to :story

  validates :story, presence: true

  mount_uploader :file, StoryImageUploader
end
