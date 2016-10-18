class AddDatesToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :start_date, :date
    add_column :competitions, :end_date, :date
  end
end
