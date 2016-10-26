class ThreeDVideo < ActiveRecord::Base
  # belongs_to :place
  # belongs_to :attrraction
  belongs_to :three_d_videoable, polymorphic: true
end
