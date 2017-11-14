module Api
  class ApiController < ActionController::API
    include SessionsHelper

    def jsonify(obj, options = { status: :ok })
      render json: obj.as_json(options), status: options[:status]
    end
  end
end
