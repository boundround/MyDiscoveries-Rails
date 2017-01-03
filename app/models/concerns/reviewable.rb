require 'active_support/concern'

module Reviewable
  extend ActiveSupport::Concern

  included do
    has_many :reviews, as: :reviewable
    has_many :quality_rates, -> { where dimension: "quality" },
                              dependent: :destroy,
                              class_name: 'Rate',
                              as: :rateable

    has_one :quality_average, -> { where dimension: "quality" },
                              as: :cacheable,
                              class_name: 'RatingCache',
                              dependent: :destroy

    has_many :quality_raters, through: :quality_rates, source: :rater
  end
end
