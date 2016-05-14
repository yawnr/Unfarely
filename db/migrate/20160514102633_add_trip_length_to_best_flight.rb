class AddTripLengthToBestFlight < ActiveRecord::Migration
  def change
    add_column :best_flights, :trip_length, :integer, null: false
  end
end
