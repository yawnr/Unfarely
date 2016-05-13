class AddTripStringToBestFlights < ActiveRecord::Migration
  def change
    add_column :best_flights, :trip_string, :string, index: true, null: false
  end
end
