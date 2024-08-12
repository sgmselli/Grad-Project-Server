class Api::V1::WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def receive
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload,
        request.headers['Stripe-Signature'],
        Rails.application.credentials.dig(:stripe, :webhook_secret) # Set your webhook secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    # Handle the event
    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']
      # Fulfill the purchase...
    # Add other events as needed
    end

    render json: { status: 'success' }, status: 200
  end

end
