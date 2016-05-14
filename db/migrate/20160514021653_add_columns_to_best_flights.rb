class AddColumnsToBestFlights < ActiveRecord::Migration
  def change
    add_column :best_flights, :round_trip, :boolean, null: false
    add_column :best_flights, :source, :string, null: false
    add_column :best_flights, :return_date, :date
  end
end
