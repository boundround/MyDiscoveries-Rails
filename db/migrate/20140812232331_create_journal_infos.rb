class CreateJournalInfos < ActiveRecord::Migration
  def change
    create_table :journal_infos do |t|

      t.timestamps
    end
  end
end
