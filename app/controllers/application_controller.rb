class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      Token.authenticate?(token)
    end
  end

  def render_unthorized
    render json: { message: 'token invalid' }, status: :unauthorized
  end
end
