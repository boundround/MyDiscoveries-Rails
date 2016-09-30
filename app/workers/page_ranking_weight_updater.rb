class PageRankingWeightUpdater
  GA_PAGE_VIEWS_WEIGHT = 0.2

  include Sidekiq::Worker

  # https://developers.google.com/analytics/devguides/reporting/core/v4/limits-quotas
  # increase "Number of requests per 100 seconds per user" from 100 (default) to 1000 (max)
  sidekiq_options throttle: { threshold: 10, period: 1.second }

  def perform(rankable_id, rankable_class)
    rankable = rankable_class.constantize.find_by(id: rankable_id)
    return if rankable.nil?

    page_ranking_weight = GA_PAGE_VIEWS_WEIGHT * rankable.ga_page_views_count
    rankable.update_column(:page_ranking_weight, page_ranking_weight)
  end
end
