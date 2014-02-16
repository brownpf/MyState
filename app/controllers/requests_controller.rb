class RequestsController < ApplicationController
require 'twilio-ruby'


  def get_requests
    requests = Request.all
    render json: requests, status: 200, example_params: false
  end

  # This method captures the incoming sms message
  def request_incoming
    # And the message text
    text = Request.store_sms(params[:Body])

    render xml: text
  end


  def create_request
    request = Request.create
    if params[:post_code]
      coords = request.reverse_geolocation(postcode)
    else
      coords = [params[:latitude], params[:longitude]]
    end

    request.store_location(coords[0], coords[1])
    request.store_status(params[:status])
    redirect_to :back
  end
end
