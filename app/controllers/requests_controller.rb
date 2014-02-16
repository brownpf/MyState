class RequestsController < ApplicationController
  def get_requests
    requests = Request.all
    render json: requests, status: 200, example_params: false
  end
end
