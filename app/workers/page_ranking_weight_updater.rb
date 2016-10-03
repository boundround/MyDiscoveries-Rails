class PageRankingWeightUpdater
  GA_PAGE_VIEWS_WEIGHT = 0.2
  ALGOLIA_CLICKS_WEIGHT = 0.2
  VIDEOS_WEIGHT = 0.2
  PHOTOS_WEIGHT = 0.2
  REVIEWS_WEIGHT = 0.2
  RATINGS_WEIGHT = 1

  include Sidekiq::Worker

  attr_accessor :rankable

  # https://developers.google.com/analytics/devguides/reporting/core/v4/limits-quotas
  # increase "Number of requests per 100 seconds per user" from 100 (default) to 1000 (max)
  sidekiq_options throttle: { threshold: 10, period: 1.second }

  def perform(rankable_id, rankable_class)
    self.rankable = rankable_class.constantize.find_by(id: rankable_id)
    return if rankable.nil?

    rankable.update_column(:page_ranking_weight, page_ranking_weight)
  end

  private

  def ga_page_views_weight
    GA_PAGE_VIEWS_WEIGHT * rankable.ga_page_views_count
  end

  def algolia_clicks_weight
    ALGOLIA_CLICKS_WEIGHT * rankable.algolia_clicks
  end

  def videos_weight
    rankable.is_a?(Place) ? VIDEOS_WEIGHT * rankable.videos.size : 0
  end

  def photos_weight
    rankable.is_a?(Place) ? PHOTOS_WEIGHT * rankable.photos.size : 0
  end

  def reviews_weight
    rankable.respond_to?(:reviews) ? REVIEWS_WEIGHT * rankable.reviews.size : 0
  end

  def rating_weight
    rankable.is_a?(Place) ? RATINGS_WEIGHT * rankable.quality_average.try(:avg).to_f : 0
  end

  def page_ranking_weight
    [
      ga_page_views_weight,
      algolia_clicks_weight,
      videos_weight,
      photos_weight,
      reviews_weight,
      rating_weight,
    ].reduce(:+)
  end
end
