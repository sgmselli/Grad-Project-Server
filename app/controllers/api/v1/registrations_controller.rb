class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'successful login' }, status: 200
    else
      render json: { error: user.errors.full_message }, status: 500
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end


end
