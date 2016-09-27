module Searchable
  extend ActiveSupport::Concern

  def primary_category_priority
    if respond_to?(:primary_category) && primary_category.present?
      case primary_category.name
      when 'Something to do'
        3
      when 'Somewhere to stay'
        2
      when 'Somewhere to eat'
        1
      else
        0
      end
    else
      0
    end
  end
end
