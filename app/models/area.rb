class Area < ActiveRecord::Base
  has_many :photos
  accepts_nested_attributes_for :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true
  validates :code, uniqueness: { case_sensitive: false }, presence: true, length: {is: 3}
  validates :short_intro, length: {maximum: 90}, presence: true
  validates :description, length: {maximum: 400}, presence: true

end
