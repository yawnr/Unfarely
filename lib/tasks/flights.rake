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

MONTHS_OF_DATA = 6

def next_month(month)
  if month <= 11
    return month + 1
  else
    return 1
  end
end

def get_year(month_one)
  if month_one < Time.now.month
    year = Time.now.year + 1
  else
    year = Time.now.year
  end

  return year
end

def get_us_airports
  Country.find_by_name("United States").airports
end

def build_url(origination, destination, trip_length, is_RT)
  start_date = "#{Time.now.strftime('%Y-%m-%d')}"

  if is_RT
    end_date = "#{(Time.now + (60 * 60 * 24 * trip_length)).strftime('%Y-%m-%d')}"
    url = "http://www.google.com/flights/#search;f=#{origination.search_string};t=#{destination.search_string};d=#{start_date};r=#{end_date}"
  else
    url = "http://www.google.com/flights/#search;f=#{origination.search_string};t=#{destination.search_string};d=#{start_date}"
  end

  return url
end

def create_or_update_records(flight_hash, origination, destination, trip_length, is_RT)
  flight_hash.each do |month, flight|
    trip_string = "#{origination.code}-#{destination.code}-#{month}-#{trip_length}-#{is_RT ? 'RT' : 'OW'}"
    current_record = BestFlight.find_by_trip_string(trip_string)
    new_record = {
                  departure_airport_id: origination.id,
                  departure_city_id: origination.city_id,
                  arrival_airport_id: destination.id,
                  arrival_city_id: destination.city_id,
                  trip_string: trip_string,
                  month: flight[:departure_date].month,
                  departure_date: flight[:departure_date],
                  return_date: flight[:return_date],
                  price: flight[:price],
                  num_similar: flight[:num_similar],
                  round_trip: is_RT,
                  source: 'google',
                  trip_length: trip_length
                 }

    if current_record
      current_record.update(new_record)
    else
      BestFlight.create(new_record)
    end

  end
end

def get_best_prices(originations, destinations, trip_length, is_RT)

  originations.each do |origination|
    destinations.each do |destination|

      next if origination.city_id == destination.city_id

      retries = 2
      begin
        driver = Selenium::WebDriver.for(:chrome)
        driver.navigate.to(build_url(origination, destination, trip_length, is_RT))
        sleep(5)

        class_string = driver.find_elements(:id, 'root')[0].attribute('class').split('-')[0]
        date_inputs = driver.find_elements(:class, "#{class_string}-G-m")
        date_inputs[0].click

        best_prices_by_month = {}

        month_one = Time.now.month

        (MONTHS_OF_DATA / 2).times do |x|
          year = get_year(month_one)
          month_two = next_month(month_one)
          days_month_one = MONTHS[month_one][:num_days]
          days_month_two = MONTHS[month_two][:num_days]

          sleep(5)

          date_nodes = driver.find_elements(:class, "#{class_string}-p-e")
          month_one_prices = []
          month_two_prices = []

          date_nodes[0...days_month_one].each_with_index do |date_node, i|
            day = i + 1

            begin
              price = date_node.find_element(:class, "#{class_string}-p-f").attribute('innerHTML').gsub(/[^\d]/, '').to_i
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              next
            end

            month_one_prices.push(price)

            best_price_month_one = best_prices_by_month[MONTHS[month_one][:name]]
            if !best_price_month_one || (price < best_price_month_one[:price])
              best_prices_by_month[MONTHS[month_one][:name]] ={price: price,
                                                               departure_date: Date.new(year, month_one, day),
                                                               return_date: is_RT ? (Date.new(year, month_one, day) + trip_length) : nil}
            end
          end

          date_nodes[days_month_one...(days_month_one + days_month_two)].each_with_index do |date_node, j|
            day = j + 1

            begin
              price = date_node.find_element(:class, "#{class_string}-p-f").attribute('innerHTML').gsub(/[^\d]/, '').to_i
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              next
            end

            month_two_prices.push(price)

            best_price_month_two = best_prices_by_month[MONTHS[month_two][:name]]
            if !best_price_month_two || (price < best_price_month_two[:price])
              best_prices_by_month[MONTHS[month_two][:name]] = {price: price,
                                                                departure_date: Date.new(year, month_two, day),
                                                                return_date: is_RT ? (Date.new(year, month_two, day) + trip_length) : nil}
            end
          end

          num_similar_one = 0
          num_similar_two = 0

          month_one_prices.each do |price|
            best = best_prices_by_month[MONTHS[month_one][:name]][:price].to_f
            if ((best - price.to_f) / best).abs < 0.1
              num_similar_one += 1
            end
          end

          best_prices_by_month[MONTHS[month_one][:name]][:num_similar] = num_similar_one

          month_two_prices.each do |price|
            best = best_prices_by_month[MONTHS[month_two][:name]][:price].to_f
            if ((best - price.to_f) / best).abs < 0.1
              num_similar_two += 1
            end
          end

          best_prices_by_month[MONTHS[month_two][:name]][:num_similar] = num_similar_two

          if (x + 1) != MONTHS_OF_DATA
            driver.find_element(:class, 'datePickerNextButton').click
            sleep(5)
            driver.find_element(:class, 'datePickerNextButton').click

            month_one = next_month(next_month(month_one))
          end
        end

        create_or_update_records(best_prices_by_month, origination, destination, trip_length, is_RT)

      rescue Exception=>e
        puts "\tCaught: #{e}"

        if retries > 0
          puts "\tTrying #{retries} more times\n"
          retries -= 1
          sleep 2
          retry
        end

      ensure
        driver.quit
      end

    end
  end
end


task :one_ways => :environment do
  originations = get_us_airports
  destinations = Airport.all
  get_best_prices(originations, destinations, 1, false)
end

task :fourteen => :environment do
  originations = get_us_airports
  destinations = Airport.all
  trip_length = 14
  get_best_prices(originations, destinations, trip_length, true)
end
