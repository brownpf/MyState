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
end
