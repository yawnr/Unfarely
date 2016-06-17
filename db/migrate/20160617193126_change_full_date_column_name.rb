class ChangeFullDateColumnName < ActiveRecord::Migration
  def change
    rename_column :best_flights, :full_date, :departure_date
  end
end
