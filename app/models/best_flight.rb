class BestFlight < ActiveRecord::Base

  validates :departure_airport_id, :arrival_airport_id, :price, :month, :departure_date, :source, :trip_string, presence: true
  validates :round_trip, inclusion: { in: [true, false] }
  validates :trip_string, uniqueness: true

  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'

end
