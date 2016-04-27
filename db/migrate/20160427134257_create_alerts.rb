class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id, null: false, index: true
      t.integer :departure_airport_id, null: false, index: true
      t.integer :arrival_airport_id, null: false, index: true
      t.integer :price, null: false

      t.timestamps null: false
    end
  end
end
