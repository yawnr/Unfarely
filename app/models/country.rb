class Country < ActiveRecord::Base

  has_many :cities
  has_many :airports, through: :cities

end
