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

ORIGINATIONS = ['JFK,EWR,LGA'] #, 'ORD,MDW', 'LAX', 'SFO', 'ATL', 'IAD,DCA,BWI']
DESTINATIONS = ['SYD', 'CHC', 'HND,NRT'] #, 'MEL', 'AKL', 'KEF,RKV', 'BKK,DMK', 'LHR,LGW,LCY,STN,LTN,QQS', 'CDG,ORY,BVA,XHP,XPG']
TIMES_TO_PAGINATE = 2

def next_month(month)
  if month <= 11
    return month + 1
  else
    return 1
  end
end

task :nyc => :environment do

  driver = Selenium::WebDriver.for(:chrome)
  start_date = "#{Time.now.strftime('%Y-%m-%d')}"
  end_date = "#{(Time.now + 1000000).strftime('%Y-%m-%d')}"

  ORIGINATIONS.each do |origination|
    DESTINATIONS.each do |destination|
      driver.navigate.to("http://www.google.com/flights/#search;f=#{origination};t=#{destination};d=#{start_date};r=#{end_date}")
      sleep(5)
      date_inputs = driver.find_elements(:class, 'MHNSJI-H-q')
      date_inputs[0].click

      best_prices_by_month = {}

      month_one = Time.now.month

      TIMES_TO_PAGINATE.times do |x|
        if month_one < Time.now.month
          year = Time.now.year + 1
        else
          year = Time.now.year
        end

        month_two = next_month(month_one)
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

          best_price_month_one = best_prices_by_month[MONTHS[month_one][:name]]
          if !best_price_month_one || (price < best_price_month_one[:price])
            best_prices_by_month[MONTHS[month_one][:name]] ={price: price, date: Date.new(year, month_one, day)}
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

          best_price_month_two = best_prices_by_month[MONTHS[month_two][:name]]
          if !best_price_month_two || (price < best_price_month_two[:price])
            best_prices_by_month[MONTHS[month_two][:name]] = {price: price, date: Date.new(year, month_two, day)}
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

        if (x + 1) != TIMES_TO_PAGINATE
          driver.find_element(:class, 'datePickerNextButton').click
          sleep(5)
          driver.find_element(:class, 'datePickerNextButton').click

          month_one = next_month(next_month(month_one))
        end
      end

      puts best_prices_by_month
    end
  end

driver.quit



    #   date = Date.new(2016,4,day)
    #   Flight.create({departure_airport_id: 1, arrival_airport_id: 1, month: 4, full_date: date, price: price})

end
