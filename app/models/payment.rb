class Payment
  include ActiveModel::Model

  attr_accessor :credit_card_number,
    :credit_card_date,
    :credit_card_holder_name,
    :credit_card_cvv

  validates :credit_card_number,
    :credit_card_date,
    :credit_card_cvv,
    :credit_card_holder_name,
    presence: true

  validate :credit_card_date_format,
  :credit_card_number_format,
  :credit_card_cvv_format

  private

  def credit_card_number_format
    card_number_length = credit_card_number.to_i.to_s.length
    if card_number_length >= 19 || card_number_length <= 13
      errors.add(:credit_card_number, 'is not valid')
    end
  end

  def credit_card_cvv_format
    if credit_card_cvv.to_i.to_s.length != 3
      errors.add(:credit_card_cvv, 'is not valid')
    end
  end

  def credit_card_date_format
    month, year = credit_card_date.split('/')
     if !month.to_i.in?(1..12) || (year.to_i <= Time.now.strftime('%y').to_i)
       errors.add(:credit_card_date, 'is not valid')
     end
  end
end
