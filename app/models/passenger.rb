class Passenger < ActiveRecord::Base
  TITLES = ['Mrs', 'Mr']

  belongs_to :order

  validates :first_name, :last_name, :order, presence: true
  validate  :valid_date_of_birth

  def valid_date_of_birth
    if date_of_birth.blank? ||
      (date_of_birth.strftime('%d/%m/%Y') != I18n.l(date_of_birth, format: :date_month_year_concise))
      errors.add(:date_of_birth, 'is not valid')
    end
  end

end
