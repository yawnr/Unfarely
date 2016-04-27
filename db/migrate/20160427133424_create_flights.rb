class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :departure_airport_id, null: false, index: true
      t.integer :departure_city_id
      t.integer :arrival_airport_id, null: false, index: true
      t.integer :arrival_city_id
      t.integer :month, null: false
      t.date :full_date, null: false, index: true
      t.integer :price, null: false

      t.timestamps null: false
    end
  end
end
