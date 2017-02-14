class CreditCard
  include ActiveModel::Model

  attr_accessor :number,
    :date,
    :holder_name,
    :cvv

  validates :number,
    :date,
    :cvv,
    :holder_name,
    presence: true

  validate :date_format, :number_format, :cvv_format

  private

  def number_format
    card_number_length = number.delete(' ').to_i.to_s.length
    if card_number_length >= 19 || card_number_length <= 13
      errors.add(:number, 'is not valid')
    end
  end

  def cvv_format
    if cvv.to_i.to_s.length < 3 || cvv.to_i.to_s.length > 4
      errors.add(:cvv, 'is not valid')
    end
  end

  def date_format
    month, year = date.delete(' ').split('/')
    year_valid  = year.blank? || month.blank?

    if year.present? && month.present?
      year_valid = if year.length == 2
        year.to_i >= Time.now.strftime('%y').to_i
      elsif year.length == 4
        year.to_i >= Time.now.strftime('%Y').to_i
      else
        false
      end
    end

     if !month.to_i.in?(1..12) || !year_valid
       errors.add(:date, 'is not valid')
     end
  end
end
