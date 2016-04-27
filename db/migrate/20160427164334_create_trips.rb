class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :departure_airport_id, null: false, index: true
      t.integer :arrival_airport_id, null: false, index: true
      t.integer :user_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
