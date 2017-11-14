module Api
  module V1
    class TrailsController < ApiController

      def index
        trails = Trail.all
        jsonify(trails)
      end

      def show
        trail = Trail.find(params[:id])
        jsonify(trail,
                include: { location: { only: [:id, :name] } },
                except: :location_id,
        )
      end

    end
  end
end
