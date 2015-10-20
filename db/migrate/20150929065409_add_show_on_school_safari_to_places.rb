class AddShowOnSchoolSafariToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :show_on_school_safari, :boolean, :default => false
    add_column :places, :school_safari_description, :text
  end
end
