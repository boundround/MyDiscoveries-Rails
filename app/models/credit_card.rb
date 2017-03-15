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
    errors.add(:number, 'is not valid') unless card_number_length.in?(14..18)
  end

  def cvv_format
    if !(/\A\d+\z/ === cvv) || !cvv.length.in?(3..4)
      errors.add(:cvv, 'is not valid')
    end
  end

  def date_format
    month, year = date.delete(' ').split('/')
    errors.add(:date, 'is not valid') unless valid_year?(year) && valid_month?(month)
  end

  def valid_year?(year)
    return false if year.blank?

    if year.length == 2
      year.to_i >= Time.now.strftime('%y').to_i
    elsif year.length == 4
      year.to_i >= Time.now.strftime('%Y').to_i
    else
      false
    end
  end

  def valid_month?(month)
    month.present? && month.to_i.in?(1..12)
  end
end
