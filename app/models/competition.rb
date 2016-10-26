class Competition < ActiveRecord::Base

  mount_uploader :image, CompetitionImageUploader

  scope :active, -> { where(status: "live").where("start_date <= ? AND end_date >= ?", Date.today, Date.today) }

end
