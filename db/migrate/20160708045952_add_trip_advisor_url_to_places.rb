class AddTripAdvisorUrlToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :trip_advisor_url, :string
  end
end
