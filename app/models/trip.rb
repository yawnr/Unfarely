class Trip < ActiveRecord::Base

  belongs_to :user
  has_many :best_flights

end
