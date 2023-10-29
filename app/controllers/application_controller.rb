class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    p request.headers['Authorization']
    authenticate_or_request_with_http_basic do |user_name, password|
      @current_user = User.find_by(username: user_name)
      return if @current_user&.authenticate(password)

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
