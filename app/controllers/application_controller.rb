class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include ActionController::Cookies

  before_action :authenticate_user!

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  def json_request?
    request.format.json?
  end

  private

  def authenticate_user!
    token = cookies.signed[:jwt]
    if token
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true)[0]
      @current_user = User.find(decoded_token['user_id'])
    else
      render json: { error: 'Not Authenticated' }, status: 401
    end

  rescue JWT::DecodeError
    render json: { error: 'Not Authenticated' }, status: 401
  end

end
