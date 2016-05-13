class Api::BestFlightsController < ApplicationController

  def index
    if current_user
      @best_flights = BestFlight.all
    else
      @best_flights = BestFlight.all.limit(25)
    end

    render 'index'
  end

  def create
    @best_flight = BestFlight.new(bestflight_params)
    @best_flight.save!
    render 'show'
  end

  def show
    @best_flight = BestFlight.find(params[:id])
    render 'show'
  end

  def update
    @best_flight = BestFlight.find(params[:id])
    @best_flight.update!(bestflight_params)
    render 'show'
  end

  def destroy
    @best_flight = BestFlight.find(params[:id])
    @best_flight.destroy!
    render 'show'
  end

  private
  def bestflight_params
    params.require(:best_flight).permit(:departure_airport_id, :arrival_airport_id, :month, :full_date, :price, :num_similar)
  end

end
