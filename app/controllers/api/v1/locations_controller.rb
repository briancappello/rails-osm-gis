module Api
  module V1
    class LocationsController < ApiController

      def index
        locations = Location.all
        jsonify(locations)
      end

      def show
        location = Location.find(params[:id])
        jsonify(location,
                include: {
                  trails: { only: [:id, :name] },
                },
        )
      end

    end
  end
end
