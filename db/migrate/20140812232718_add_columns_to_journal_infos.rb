class AddColumnsToJournalInfos < ActiveRecord::Migration
  def change
    add_column :journal_infos, :place_id, :integer
  end
end
