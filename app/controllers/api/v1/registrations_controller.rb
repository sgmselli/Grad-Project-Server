class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:create]  # Make sure only create is excluded from authentication

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'Registration successful' }, status: :created  # Use 201 Created
    else
      puts(user.errors.full_messages)
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity  # Use 422 Unprocessable Entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
