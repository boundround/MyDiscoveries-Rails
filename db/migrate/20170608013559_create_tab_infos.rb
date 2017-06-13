class CreateTabInfos < ActiveRecord::Migration
  def change
    create_table :tab_infos do |t|
    	t.string  :title
      t.text    :description
      t.string  :image
      t.integer :tab_infoable_id
      t.string  :tab_infoable_type

      t.timestamps
    end
  end
end