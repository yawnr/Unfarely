MONTHS = {
  1 => {name: 'January', num_days: 31},
  2 => {name: 'February', num_days: Time.now.month > 2 ? Time.days_in_month(2, Time.now.year + 1) : Time.days_in_month(2, Time.now.year)},
  3 => {name: 'March', num_days: 31},
  4 => {name: 'April', num_days: 30},
  5 => {name: 'May', num_days: 31},
  6 => {name: 'June', num_days: 30},
  7 => {name: 'July', num_days: 31},
  8 => {name: 'August', num_days: 31},
  9 => {name: 'September', num_days: 30},
  10 => {name: 'October', num_days: 31},
  11 => {name: 'November', num_days: 30},
  12 => {name: 'December', num_days: 31}
}

# ORIGINATIONS = ['NYC'] #, 'ORD,MDW', 'LAX', 'SFO', 'ATL', 'IAD,DCA,BWI']
# DESTINATIONS = ['SYD'] #, 'MEL', 'AKL', 'KEF,RKV', 'BKK,DMK', 'LHR,LGW,LCY,STN,LTN,QQS', 'CDG,ORY,BVA,XHP,XPG']
TIMES_TO_PAGINATE = 2

def next_month(month)
  if month <= 11
    return month + 1
  else
    return 1
  end
end

def get_year(month)
  if month < Time.now.month
    year = Time.now.year + 1
  else
    year = Time.now.year
  end

  return year
end

def get_us_airports
  Country.find_by_name("United States").airports
end

def build_url(origination, destination)
  start_date = "#{Time.now.strftime('%Y-%m-%d')}"
  end_date = "#{(Time.now + 1000000).strftime('%Y-%m-%d')}"
  url = "http://www.google.com/flights/#search;f=#{origination.search_string};t=#{destination.search_string};d=#{start_date};r=#{end_date}"
  return url
end

task :flights => :environment do

  originations = get_us_airports
  destinations = Airport.all

  driver = Selenium::WebDriver.for(:chrome)

  originations.each do |origination|
    destinations.each do |destination|

      next if origination.city_id == destination.city_id

      driver.navigate.to(build_url(origination, destination))
      sleep(5)

      date_inputs = driver.find_elements(:class, 'MHNSJI-H-q')
      date_inputs[0].click

      best_prices_by_month = {}

      month_one = Time.now.month

      TIMES_TO_PAGINATE.times do |x|
        year_one = get_year(month_one)
        month_two = next_month(month_one)
        year_two = get_year(month_two)

        days_month_one = MONTHS[month_one][:num_days]
        days_month_two = MONTHS[month_two][:num_days]

        sleep(5)

        date_nodes = driver.find_elements(:class, 'MHNSJI-p-e')
        month_one_prices = []
        month_two_prices = []

        date_nodes[0...days_month_one].each_with_index do |date_node, i|
          day = i + 1

          begin
            price = date_node.find_element(:class, 'MHNSJI-p-f').attribute('innerHTML').gsub(/[^\d]/, '').to_i
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            next
          end

          month_one_prices.push(price)

          best_price_month_one = best_prices_by_month[month_one]
          if !best_price_month_one || (price < best_price_month_one[:price])
            best_prices_by_month[month_one] ={price: price, date: Date.new(year_one, month_one, day)}
          end
        end

        date_nodes[days_month_one...(days_month_one + days_month_two)].each_with_index do |date_node, j|
          day = j + 1

          begin
            price = date_node.find_element(:class, 'MHNSJI-p-f').attribute('innerHTML').gsub(/[^\d]/, '').to_i
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            next
          end

          month_two_prices.push(price)

          best_price_month_two = best_prices_by_month[month_two]
          if !best_price_month_two || (price < best_price_month_two[:price])
            best_prices_by_month[month_two] = {price: price, date: Date.new(year_two, month_two, day)}
          end
        end

        num_similar_one = 0
        num_similar_two = 0

        month_one_prices.each do |price|
          best = best_prices_by_month[month_one][:price].to_f
          if ((best - price.to_f) / best).abs < 0.1
            num_similar_one += 1
          end
        end

        best_prices_by_month[month_one][:num_similar] = num_similar_one

        month_two_prices.each do |price|
          best = best_prices_by_month[month_two][:price].to_f
          if ((best - price.to_f) / best).abs < 0.1
            num_similar_two += 1
          end
        end

        best_prices_by_month[month_two][:num_similar] = num_similar_two

        if (x + 1) != TIMES_TO_PAGINATE
          driver.find_element(:class, 'datePickerNextButton').click
          sleep(5)
          driver.find_element(:class, 'datePickerNextButton').click

          month_one = next_month(next_month(month_one))
        end
      end

      best_prices_by_month.each do |month, flight|
        trip_string = "#{origination.code}-#{destination.code}-#{month}"
        current_record = BestFlight.find_by_trip_string(trip_string)
        if current_record
          current_record.update({departure_airport_id: origination.id, departure_city_id: origination.city_id,
            arrival_airport_id: destination.id,  arrival_city_id: destination.city_id, trip_string: trip_string,
            month: month, full_date: flight[:date], price: flight[:price], num_similar: flight[:num_similar]})
        else
          BestFlight.create({departure_airport_id: origination.id, departure_city_id: origination.city_id,
            arrival_airport_id: destination.id,  arrival_city_id: destination.city_id, trip_string: trip_string,
            month: month, full_date: flight[:date], price: flight[:price], num_similar: flight[:num_similar]})
        end
      end

    end
  end

driver.quit

end
