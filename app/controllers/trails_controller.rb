class TrailsController < ApplicationController
  def show
    @trail = Trail.find(params[:id])
    if logged_in?
      @rides = @trail.rides.where(user: current_user)
    end
  end
end
