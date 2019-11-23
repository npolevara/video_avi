class ApplicationController < ActionController::API
  before_action :check_signed_user, except: :routing_error
  rescue_from StandardError do |exception|
    render json: exception, status: :internal_server_error
  end

  def routing_error
    render :nothing => true, status: :not_found
  end

  def signed_user
    @user ||= User.where(authentication_token: required_params[:authentication_token]).first if required_params
  end

  private

  def check_signed_user
    redirect_to controller: 'api/v1/users', action: 'signin' unless signed_user
  end

  def required_params
    token = params.permit(:authentication_token, :source, :name, :cut_from, :cut_length)
    return if token.to_h.empty?
    token
  end

end
