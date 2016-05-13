class Trip < ActiveRecord::Base

  validates :departure_airport_id, :arrival_airport_id, :trip_string, presence: true

  belongs_to :user
  has_many :best_flights

end
