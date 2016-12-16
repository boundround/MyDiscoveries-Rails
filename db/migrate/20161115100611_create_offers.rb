class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :attraction_id
      t.string :status, default: ""
      t.string :name, default: ""
      t.string :description, default: ""
      t.integer :minRateAdult, default: 0
      t.integer :minRateChild, default: 0
      t.integer :minRateInfant, default: 0
      t.integer :maxRateAdult, default: 0
      t.integer :maxRateChild, default: 0
      t.integer :maxRateInfant, default: 0
      t.integer :duration, default: 0
      t.integer :duration, default: 0
      t.string :specialNotes, default: ""
      t.integer :operatingDays, default: 0
      t.string :operatingDaysStr, default: ""
      t.string :operatingSchedule, default: ""
      t.string :locationStart, default: ""
      t.decimal :latitudeStart, { precision: 10, scale: 6 }
      t.decimal :longitudeStart, { precision: 10, scale: 6 }
      t.integer :distanceStartToRef, default: 0
      t.string :locationEnd, default: ""
      t.decimal :latitudeEnd, { precision: 10, scale: 6 }
      t.decimal :longitudeEnd, { precision: 10, scale: 6 }
      t.string :tags, array: true, default: []
      t.integer :minAge, default: 0
      t.integer :maxAge, default: 0
      t.integer :requiredMultiple, default: 0
      t.integer :minUnits, default: 0
      t.integer :maxUnits, default: 0
      t.string :pickupNotes, default: ""
      t.string :dropoffNotes, default: ""
      t.string :highlightsStr, default: ""
      t.string :itineraryStr, default: ""
      t.string :includes, default: ""
      t.string :sellVouchers, default: ""
      t.string :onlyVouchers, default: ""
      t.string :voucherInstructions, default: ""
      t.integer :voucherValidity, default: 0
      t.string :customStr1, default: ""
      t.string :customStr2, default: ""
      t.string :customStr3, default: ""
      t.string :customStr4, default: ""
      t.boolean :pickupRequired, default: false

      t.timestamps
    end

    add_index :offers, :attraction_id
  end
end
