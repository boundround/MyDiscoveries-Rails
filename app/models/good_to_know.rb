class GoodToKnow < ActiveRecord::Base
  belongs_to :good_to_knowable, polymorphic: true
end
