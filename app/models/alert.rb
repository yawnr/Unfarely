class Alert < ActiveRecord::Base

  validates :departure_airport_id, :arrival_airport_id, :price, presence: true

  belongs_to :user

end
