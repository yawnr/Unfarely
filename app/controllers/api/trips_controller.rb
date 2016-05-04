class Api::TripsController < ApplicationController

  def index
    if current_user
      @trips = current_user.trips
      render 'index'
    else
      redirect_to(new_session_url)
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    # add trip.trip_string = dep + "-" + arr
    @trip.save!
    render 'show'
  end

  def show
    @trip = Trip.find(params[:id])
    render 'show'
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.update!(trip_params)
    render 'show'
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy!
    render 'show'
  end

  private
  def trip_params
    # add :alert (boolean) and :alert_price (integer) via new migration
    # maybe add a date range?
    params.require(:trip).permit(:departure_airport_id, :arrival_airport_id, :user_id)
  end

end
