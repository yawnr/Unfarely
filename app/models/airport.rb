class Airport < ActiveRecord::Base

  belongs_to :city
  has_many :country, through: :city

end
