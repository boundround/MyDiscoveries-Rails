class Place < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged
  validates_presence_of :display_name, :slug

  belongs_to :area
end
