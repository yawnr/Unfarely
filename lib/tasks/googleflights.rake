task :nycla => :environment do

  NUM_MONTHS = 1

  driver = Selenium::WebDriver.for(:chrome)

  start_date = "#{Time.now.strftime('%Y-%m-%d')}"
  end_date = "#{(Time.now + 1000000).strftime('%Y-%m-%d')}"

  driver.navigate.to("http://www.google.com/flights/#search;f=JFK,EWR,LGA;t=LAX;d=#{start_date};r=#{end_date}")
  sleep(5)
  date_inputs = driver.find_elements(:class, 'MHNSJI-H-q')
  date_inputs[0].click

  all_prices = {}

  NUM_MONTHS.times do |x|
    sleep(5)
    price_nodes = driver.find_elements(:class, 'MHNSJI-p-f')
    prices = []

    price_nodes.each do |price_node|
      prices.push(price_node.attribute("innerHTML"))
    end

    all_prices["Month_#{x + 1}"] = prices
    driver.find_element(:class, 'datePickerNextButton').click
  end

  driver.quit
  
  puts all_prices

  day = 28
  3.times do |idx|
    date = Date.new(2016,4,day)
    price = all_prices['Month_1'][idx][/\d+/].to_i
    Flight.create({departure_airport_id: 1, arrival_airport_id: 1, month: 4, full_date: date, price: price})
    day += 1
  end



end
