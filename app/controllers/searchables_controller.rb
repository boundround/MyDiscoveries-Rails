class SearchablesController < ApplicationController
  def algolia_click
    searchable_type, searchable_id = params[:object_id].split('_')
    searchable = searchable_type.camelize.constantize.find(searchable_id)
    searchable.update_column(:algolia_clicks, searchable.algolia_clicks + 1)
    head :ok
  end
end
