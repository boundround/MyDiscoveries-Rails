class AddSourcetoSearchQueries < ActiveRecord::Migration
  def change
    add_column :search_queries, :source, :string
  end
end
