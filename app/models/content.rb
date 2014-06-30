class Content < ActiveRecord::Base
  belongs_to :place

  validates :description, presence: true
end
