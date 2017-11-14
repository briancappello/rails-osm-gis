class RidesController < ApplicationController

  before_action :require_auth

  def index
    @rides = current_user.rides
  end

  def show
    @ride = Ride.find(params[:id])
  end

end
