class CreateWebresources < ActiveRecord::Migration  
  def change
    create_table :webresources do |t|
      t.string :caption
      t.string :path
      t.references :program, index: true

      t.timestamps
    end
  end
end
