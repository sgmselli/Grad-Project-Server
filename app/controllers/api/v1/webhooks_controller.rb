class Api::V1::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload,
        request.headers['Stripe-Signature'],
        webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']
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
      begin
        handlePaidSession(session)
        puts('yay')
      rescue => e
        Rails.logger.error("Error handling paid session: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        render json: { error: 'Internal server error' }, status: 500 and return
      end
    end

    render json: { status: 'success' }, status: 200
  end

  private

  def handlePaidSession(session)
    if session['payment_status'] == 'paid'
      # The user has successfully paid
      customer_email = session['customer_email']
      subscription_id = session['subscription'] # If it's a subscription, this will be present

      user = User.find_by(email: customer_email)

      if user.present?
        # Update the stripe_customer_id for the user
        if user.update!(stripe_customer_id: subscription_id)
          puts('Stripe customer ID updated successfully!')
        else
          Rails.logger.error('Failed to update user: ' + user.errors.full_messages.join(", "))
        end
      else
        Rails.logger.error('User not found for the given customer email: #{customer_email}')
      end

      # Optionally send a confirmation email
      # UserMailer.confirmation_email(user).deliver_later
    else
      # Handle cases where payment was not successful
      Rails.logger.info("Payment was not successful for session ID: #{session['id']}")
    end
  end

end
