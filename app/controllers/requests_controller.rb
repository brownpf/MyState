class RequestsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  require 'twilio-ruby'


  def get_requests
    requests = Request.all
    render json: requests, status: 200, example_params: false
  end

  # This method that captures the incoming SMS message
  def request_incoming
    # Grab the phone number for the message
    # And the message text
    from = params[:From]
    body = params[:Body]

    # Create a request
    r = Request.new
    text = r.store_sms(body, from)

    # Return the message back out
    render xml: text
  end


  def create_request
    request = Request.create
    if params[:post_code].present?
      coords = request.reverse_geolocation(params[:post_code])
    else
      coords = [params[:latitude], params[:longitude]]
    end
    request.update(telephone: params[:telephone])
    request.store_coords(coords[:lat],coords[:lon])
    request.store_status(params[:email][:status])
    redirect_to :back
  end
end
