require 'stripe'

class Api::V1::SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create_checkout_session
    puts(current_user)
    session = Stripe::Checkout::Session.create(

      payment_method_types: ['card'],
      line_items: [
        {
          price: 'price_1PmvvgJj7Gv26408kP22tl53', # Replace with your Price ID from Stripe
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: 'http://localhost:3001/success', # Your success URL
      cancel_url: 'http://localhost:3001/cancel',   # Your cancel URL
      customer_email: current_user.email # Pass the email from params
    )

    render json: { url: session.url }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: 500
  end
end
#   def create

#     payment_method_id = params[:payment_method_id]


#     customer = Stripe::Customer.create(
#       email: 'test@gmail.com',
#       # email: current_user.email,
#       payment_method: payment_method_id,
#       invoice_settings: {
#         default_payment_method: payment_method_id,
#       },
#     )

#     subscription = Stripe::Subscription.create(
#       customer: customer.id,
#       items: [{ price: 'price_1PmvvgJj7Gv26408kP22tl53' }], # Replace with your price ID
#       # expand: ['latest_invoice.payment_intent'],
#     )

#     render json: { subscription: subscription }, status: 200
#   # rescue Stripe::StripeError => e
#   #   render json: { error: e.message }, status: 500
#   end

# end
