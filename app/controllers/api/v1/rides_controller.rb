module Api
  module V1
    class RidesController < ApiController

      def index
        rides = current_user.rides
        jsonify(rides)
      end

      def show
        ride = Ride.find(params[:id])
        jsonify(ride,
                include: :trail,
                except: :trail_id,
                methods: :bounds_center,
        )
      end

    end
  end
end
