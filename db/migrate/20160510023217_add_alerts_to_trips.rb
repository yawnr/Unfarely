class AddAlertsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :alert, :boolean, :default => false, null: false
    add_column :trips, :alert_price, :integer
  end
end
