class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.string :status, default: ""
      t.string :name, default: ""
      t.string :companyName, default: ""
      t.string :code, default: ""
      t.string :tradingName, default: ""
      t.string :businessNumber, default: ""
      t.string :description, default: ""
      t.integer :tncId, default: 0
      t.boolean :demo, default: false
      t.string :address1, default: ""
      t.string :address2, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :postcode, default: ""
      t.float :latitude, { precision: 10, scale: 6 }
      t.float :longitude, { precision: 10, scale: 6 }
      t.string :country, default: ""
      t.string :language, default: ""
      t.string :contactName, default: ""
      t.string :email, default: ""
      t.string :phone, default: ""
      t.string :fax, default: ""
      t.string :website, default: ""
      t.string :resContactName, default: ""
      t.string :resEmail, default: ""
      t.string :resPhone, default: ""
      t.string :accountsEmail, default: ""
      t.string :currency, default: ""
      t.string :logoUrl, default: ""
      t.string :tags, array: true, default: []
      t.string :tncUrl, default: ""

      t.timestamps
    end
  end
end
