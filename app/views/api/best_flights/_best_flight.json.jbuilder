json.extract! best_flight, :id, :departure_airport_id, :departure_city_id, :arrival_airport_id, :arrival_city_id, :month, :departure_date, :return_date, :price, :trip_length, :trip_string
json.departure_airport Airport.find(best_flight.departure_airport_id)
json.arrival_airport Airport.find(best_flight.arrival_airport_id)
json.departure_city Airport.find(best_flight.departure_airport_id).city
json.arrival_city Airport.find(best_flight.arrival_airport_id).city
