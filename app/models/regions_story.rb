class RegionsStory < ActiveRecord::Base
  belongs_to :region
  belongs_to :story
end
