class AddPageRankingWeightToSearchableTables < ActiveRecord::Migration
  def change
    add_column :places, :page_ranking_weight, :decimal
    add_column :posts, :page_ranking_weight, :decimal
    add_column :countries, :page_ranking_weight, :decimal
    add_column :stories, :page_ranking_weight, :decimal
  end
end
