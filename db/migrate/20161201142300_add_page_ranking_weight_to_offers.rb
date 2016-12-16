class AddPageRankingWeightToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :page_ranking_weight, :decimal
  end
end
