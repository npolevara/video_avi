class ApplicationController < ActionController::API

  def signed_user
    @user ||= User.where(authentication_token: required_params[:authentication_token]).first if required_params
  end

  private

  def required_params
    token = params.permit(:authentication_token, :source, :name, :length, :cut_from, :cut_to)
    return if token.to_h.empty?
    token
  end
end
