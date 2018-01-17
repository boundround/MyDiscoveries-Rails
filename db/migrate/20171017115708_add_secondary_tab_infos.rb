class AddSecondaryTabInfos < ActiveRecord::Migration
  def change
    create_table "secondary_tab_infos" do |t|
      t.string   "title"
      t.text     "description"
      t.string   "image"
      t.integer  "secondary_tab_infoable_id"
      t.string   "secondary_tab_infoable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "credit",                      default: ""
    end
  end
end
