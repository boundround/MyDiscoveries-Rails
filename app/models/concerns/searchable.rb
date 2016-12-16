module Searchable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  def self.custom_ranking
    [
      'desc(is_country)',
      'desc(is_area)',
      'desc(primary_category_priority)',
      'desc(page_ranking_weight)',
      'desc(has_hero_image)',
    ]
  end

  def accessibility
    subcategories.where(category_type: 'accessibility').map{ |sub|  sub.name }
  end

  def best_time_to_visit
    subcategories.where(category_type: 'optimum_time').map { |sub| sub.name }
  end

  def weather
    subcategories.where(category_type: 'weather').map { |sub| sub.name }
  end

  def price
    subcategories.where(category_type: 'price').map { |sub| sub.name }
  end

  def age_range
    if minimum_age.present? and maximum_age.present?
      if minimum_age > 12
        ["Teens"]
      elsif minimum_age > 8 && maximum_age < 13
        ["For Ages 9-12"]
      elsif minimum_age > 8
        ["For Ages 9-12", "Teens"]
      elsif maximum_age < 13
        ["For Ages 5-8", "For Ages 9-12"]
      elsif maximum_age < 9
        ["For Ages 5-8"]
      else
        ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
      end
    else
      ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
    end
  end

  def hero_photo
    hero_h = photos.where(photos: { hero: true })
    hero_h += user_photos.where(user_photos: { hero: true })
    hero_h = hero_h.first
    hero = {}
    if hero_h.present?
      hero= { url: hero_h.path_url(:small), alt_tag: hero_h.caption }
    else
      hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
    end
    hero
  end

  def accessible
    if subcategories.any? { |sub| sub.category_type == "accessibility" }
      "accessible"
    else
      ""
    end
  end

  def main_category
    primary_category.name if primary_category.present?
  end

  def subcategory
    subcategories.subcats.map { |sub| sub.name }
  end

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

  def ga_page_views_count
    page_path = send("#{self.class}_path".downcase, slug)
    GoogleAnalyticsPageViewsCounter.new(page_path).call
  end
end
