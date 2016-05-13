# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Country.create({name: 'United States'})
Country.create({name: 'Australia'})
City.create({name: 'New York City', country_id: 1})
City.create({name: 'Sydney', country_id: 2})
Airport.create({code: 'NYC', name: 'NYC - all airports', city_id: 1, search_string: 'JFK,LGA,EWR'})
Airport.create({code: 'JFK', name: "JFK International Airport", city_id: 1, search_string: 'JFK'})
Airport.create({code: 'LGA', name: "Laguardia International Airport", city_id: 1, search_string: 'LGA'})
Airport.create({code: 'EWR', name: "Newark International Airport", city_id: 1, search_string: 'EWR'})
Airport.create({code: 'SYD', name: "Sydney International Airport", city_id: 2, search_string: 'SYD'})
Trip.create({departure_airport_id: 1, arrival_airport_id: 5, user_id: 1, trip_string: 'NYC-SYD-7'})
