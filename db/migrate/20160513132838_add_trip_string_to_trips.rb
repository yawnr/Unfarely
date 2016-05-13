class AddTripStringToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :trip_string, :string, index: true, null: false
  end
end
