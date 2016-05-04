class Api::CitiesController < ApplicationController

  def index
    @cities = City.all
    render 'index'
  end

  def create
    @city = City.new(city_params)
    @city.save!
    render 'show'
  end

  def show
    @city = City.find(params[:id])
    render 'show'
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy!
    render 'show'
  end

  private
  def city_params
    params.require(:city).permit(:name, :country_id)
  end

end
