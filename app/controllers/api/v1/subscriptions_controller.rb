require 'stripe'

class Api::V1::SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def cancel_unsubscribe 
    subscription_id = current_user.stripe_customer_id

    begin
      # Retrieve the subscription
      subscription = Stripe::Subscription.retrieve(subscription_id)
      
      subscription = Stripe::Subscription.update(
        subscription_id,
        { cancel_at_period_end: false } # Set this to true to cancel at the end of the billing cycle
      )

      render json: { message: "Subscription canceled successfully." }, status: 200
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: 500
    end

  end

  def unsubscribe 
    subscription_id = current_user.stripe_customer_id

    begin
      # Retrieve the subscription
      subscription = Stripe::Subscription.retrieve(subscription_id)

      subscription = Stripe::Subscription.update(
        subscription_id,
        { cancel_at_period_end: true } # Set this to true to cancel at the end of the billing cycle
      )

      render json: { message: "Subscription canceled successfully." }, status: 200
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: 500
    end

  end

  def create_checkout_session
    session = Stripe::Checkout::Session.create(

      payment_method_types: ['card'],
      line_items: [
        {
          price: 'price_1Pn23yJj7Gv26408plGDAZ9S', # Replace with your Price ID from Stripe
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: 'http://localhost:3001/menu', # Your success URL
      cancel_url: 'http://localhost:3001/subscribe',   # Your cancel URL
      customer_email: current_user.email # Pass the email from params
    )

    render json: { url: session.url }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: 500
  end
end
