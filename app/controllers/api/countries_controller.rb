class Api::CountriesController < ApplicationController

  def index
    @countries = Country.all
    render 'index'
  end

  def create
    @country = Country.new(country_params)
    @country.save!
    render 'show'
  end

  def show
    @country = Country.find(params[:id])
    render 'show'
  end

  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    render 'show'
  end

  private
    def country_params
      params.require(:country).permit(:name)
    end

end
