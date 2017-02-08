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

  validate :date_format,
  :number_format,
  :cvv_format

  private

  def number_format
    card_number_length = number.to_i.to_s.length
    if card_number_length >= 19 || card_number_length <= 13
      errors.add(:number, 'is not valid')
    end
  end

  def cvv_format
    if cvv.to_i.to_s.length != 3
      errors.add(:cvv, 'is not valid')
    end
  end

  def date_format
    month, year = date.split('/')
     if !month.to_i.in?(1..12) || (year.to_i <= Time.now.strftime('%y').to_i)
       errors.add(:date, 'is not valid')
     end
  end
end
