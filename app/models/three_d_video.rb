class ThreeDVideo < ActiveRecord::Base
  belongs_to :three_d_videoable, polymorphic: true
end
