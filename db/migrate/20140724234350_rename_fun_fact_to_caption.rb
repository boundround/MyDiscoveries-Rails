class RenameFunFactToCaption < ActiveRecord::Migration
  def change
    rename_column :photos, :fun_fact, :caption
  end
end
