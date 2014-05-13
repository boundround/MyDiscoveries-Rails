class Area < ActiveRecord::Base
  has_many :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true
  validates :code, uniqueness: { case_sensitive: false }, presence: true, length: {is: 3}
  validates :short_intro, length: {maximum: 90}
  validates :description, length: {maximum: 400}

end
