class CreateCustomReports < ActiveRecord::Migration
  def change
    create_table :custom_reports do |t|

      t.timestamps
    end
  end
end
