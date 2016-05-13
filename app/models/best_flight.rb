class BestFlight < ActiveRecord::Base

  validates :departure_airport_id, :arrival_airport_id, :price, :month, :full_date, :trip_string, presence: true
  validates :trip_string, uniqueness: true

  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'

end
