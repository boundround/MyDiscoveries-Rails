namespace :page_ranking_weight do
  desc 'Update page ranking weight for all searchable models'
  task :update => :environment do
    [Place, Post, Country, Story].each do |rankable_class|
      rankable_class.find_each do |rankable|
        PageRankingWeightUpdater.perform_async(rankable.id, rankable_class.to_s)
      end
    end
  end
end
