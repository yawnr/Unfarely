class AddNumSimilarToBestFlights < ActiveRecord::Migration
  def change
    add_column :best_flights, :num_similar, :integer
  end
end
