class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: [:create]

  def validate 
    if current_user
      render json: true
    else
      # puts(current_user.email)
      render json: false
    end
  end

  def check_subscription
    if current_user.stripe_customer_id.present?
      begin
        subscription = Stripe::Subscription.retrieve(current_user.stripe_customer_id)

        render json:  subscription 
      rescue Stripe::StripeError => e
        render json: {  subscribed: false }
      end
    else
      render json: { subscribed: false }
    end
  end

  def create 
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = user.generate_jwt
      cookies.signed[:jwt] = { value: token, http_only: true, expires: 24.hour.from_now, secure: Rails.env.production? }
      render json: { message: 'successful login' }, status: 200
    else
      render json: { error: 'invalid email or password'}, status: 400
    end
  end

  def destroy
    cookies.delete(:jwt)
    # reset_session
    render json: { message: 'signed out successfully'}, status: 200
  end

end
