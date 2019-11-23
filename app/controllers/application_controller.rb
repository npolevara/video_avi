class ApplicationController < ActionController::API
  before_action :check_signed_user

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
