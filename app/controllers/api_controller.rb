class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def get_requests
    # ugly controller :(
    if params[:distance].present?
      distance = params[:distance]
    else
      distance = 5
    end
    if params[:status].present?
      requests = Request.where(status: params[:status])
    else
      requests = Request.all
    end
    requests = requests.near([params[:latitude], params[:longitude], distance, :order => :distance, :units => :mi)
    render json: requests, status: 200, example_params: false
  end
end
