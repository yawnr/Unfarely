class Api::AlertsController < ApplicationController

  def index
    if current_user
      @alerts = current_user.alerts
      render 'index'
    else
      redirect_to(new_session_url)
    end
  end

  def create
    alert = Alert.new(alert_params)
    alert.user_id = current_user.id
    alert.save!
    render json: alert
  end

  def show
    alert = Alert.find(params[:id])
    render json: alert
  end

  def update
    alert = Alert.find(params[:id])
    alert.update!(alert_params)
    render json: alert
  end

  def destroy
    alert = Alert.find(params[:id])
    alert.destroy!
    render json: alert
  end

  private
  def alert_params
    params.require(:alert).permit(:departure_airport_id, :arrival_airport_id, :price)
  end

end
