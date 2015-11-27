class BugPost < ActiveRecord::Base
  mount_uploader :screen_shot, UserAvatarUploader
  process_in_background :screen_shot
end
