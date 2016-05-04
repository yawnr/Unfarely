class Api::AirportsController < ApplicationController

  def index
    if current_user
      @airports = current_user.airports
    else
      @airports = Airport.all
    end

    render 'index'
  end

  def create
    @airport = Airport.new(airport_params)
    @airport.save!
    render 'show'
  end

  def show
    @airport = Airport.find(params[:id])
    render 'show'
  end

  def destroy
    @airpot = Airport.find(params[:id])
    @airport.destroy!
    render 'show'
  end

  private
  def airport_params
    params.require(:airport).permit(:code, :name, :search_string, :city_id)
  end

end
